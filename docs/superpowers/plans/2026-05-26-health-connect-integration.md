# Health Connect Integration Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Read sleep, heart rate, HRV, and resting heart rate from Health Connect on Android and display alongside the user's CBT-I sleep diary as informational overlay. Diary remains source of truth for the sleep-restriction algorithm.

**Architecture:** Foreground-only sync via the `health` pub package. New Drift table `sleep_records` mirrors Health Connect sessions with one-row-per-session natural key on `sessionStart`. Read-only, no backfill, no write-back. Settings toggle from day 1, mid-program nudge once user enters week 2 of protocol.

**Tech Stack:** Flutter 3.41.9 + Dart 3.11.5+, Drift (SQLite), Riverpod 3, `health: ^11.x`, `shared_preferences`, `go_router`.

**Spec:** [`docs/superpowers/specs/2026-05-26-health-connect-integration-design.md`](../specs/2026-05-26-health-connect-integration-design.md)

---

## Conventions

- Run `dart run build_runner build --delete-conflicting-outputs` after any change to a Drift table or Freezed class.
- Tests use in-memory Drift: `NoctosDatabase(NativeDatabase.memory())`. No mock libraries.
- Each task ends with a commit. Use Conventional Commits style matching existing history (`feat:`, `fix:`, `refactor:`, `docs:`, `test:`, `chore:`).
- Run `flutter test` before every commit. Run `flutter analyze` before pushing.

---

## Phase 1 — Data Layer

### Task 1: Add `health` package dependency

**Files:**
- Modify: `pubspec.yaml`

- [ ] **Step 1: Add dependency under `dependencies:` in `pubspec.yaml`**

Insert after `permission_handler: ^12.0.1`:

```yaml
  health: ^11.1.1
```

- [ ] **Step 2: Fetch dependency**

Run: `flutter pub get`
Expected: `Got dependencies!` with `health 11.x.x` resolved.

- [ ] **Step 3: Verify it compiles**

Run: `flutter analyze lib/`
Expected: No new errors.

- [ ] **Step 4: Commit**

```bash
git add pubspec.yaml pubspec.lock
git commit -m "chore: add health package for Health Connect integration"
```

---

### Task 2: Create domain models (`SleepStage`, `SleepRecord`, `SleepStageSpan`)

**Files:**
- Create: `lib/services/health/models.dart`
- Test: `test/services/health/models_test.dart`

- [ ] **Step 1: Write failing test for `SleepStage.fromHealth`**

Create `test/services/health/models_test.dart`:

```dart
import 'package:flutter_test/flutter_test.dart';
import 'package:noctos/services/health/models.dart';

void main() {
  group('SleepStage.fromHealthValue', () {
    test('maps Health Connect stage ints to enum', () {
      // health pub package uses these int codes for HC stages:
      // 1=AWAKE, 2=SLEEPING, 3=OUT_OF_BED, 4=LIGHT, 5=DEEP, 6=REM, 7=UNKNOWN
      expect(SleepStage.fromHealthValue(1), SleepStage.awake);
      expect(SleepStage.fromHealthValue(4), SleepStage.light);
      expect(SleepStage.fromHealthValue(5), SleepStage.deep);
      expect(SleepStage.fromHealthValue(6), SleepStage.rem);
      expect(SleepStage.fromHealthValue(99), SleepStage.unknown);
    });
  });

  group('SleepRecord.totalMinutes', () {
    test('computes duration from session window', () {
      final start = DateTime(2026, 5, 26, 23, 30);
      final end = DateTime(2026, 5, 27, 6, 0);
      final record = SleepRecord(
        sessionStart: start,
        sessionEnd: end,
        stages: const [],
        hrAvgBpm: null,
        hrvAvgMs: null,
        restingHrBpm: null,
        sourceApp: null,
        sourceDevice: null,
      );
      expect(record.totalMinutes, 6 * 60 + 30);
    });
  });

  group('SleepStageSpan JSON roundtrip', () {
    test('encodes and decodes', () {
      final span = SleepStageSpan(
        start: DateTime.utc(2026, 5, 26, 23, 30),
        end: DateTime.utc(2026, 5, 26, 23, 45),
        stage: SleepStage.light,
      );
      final json = span.toJson();
      final back = SleepStageSpan.fromJson(json);
      expect(back.start, span.start);
      expect(back.end, span.end);
      expect(back.stage, span.stage);
    });
  });
}
```

- [ ] **Step 2: Run test, verify it fails**

Run: `flutter test test/services/health/models_test.dart`
Expected: FAIL — `Target of URI doesn't exist: 'package:noctos/services/health/models.dart'`.

- [ ] **Step 3: Implement models**

Create `lib/services/health/models.dart`:

```dart
import 'dart:convert';

enum SleepStage {
  awake,
  light,
  deep,
  rem,
  outOfBed,
  unknown;

  static SleepStage fromHealthValue(int v) {
    switch (v) {
      case 1:
        return SleepStage.awake;
      case 3:
        return SleepStage.outOfBed;
      case 4:
        return SleepStage.light;
      case 5:
        return SleepStage.deep;
      case 6:
        return SleepStage.rem;
      case 2:
      case 7:
      default:
        return SleepStage.unknown;
    }
  }
}

class SleepStageSpan {
  SleepStageSpan({required this.start, required this.end, required this.stage});

  final DateTime start;
  final DateTime end;
  final SleepStage stage;

  Map<String, dynamic> toJson() => {
        'start': start.toUtc().millisecondsSinceEpoch,
        'end': end.toUtc().millisecondsSinceEpoch,
        'stage': stage.name,
      };

  factory SleepStageSpan.fromJson(Map<String, dynamic> j) => SleepStageSpan(
        start: DateTime.fromMillisecondsSinceEpoch(j['start'] as int, isUtc: true),
        end: DateTime.fromMillisecondsSinceEpoch(j['end'] as int, isUtc: true),
        stage: SleepStage.values.byName(j['stage'] as String),
      );

  Duration get duration => end.difference(start);
}

class SleepRecord {
  SleepRecord({
    required this.sessionStart,
    required this.sessionEnd,
    required this.stages,
    required this.hrAvgBpm,
    required this.hrvAvgMs,
    required this.restingHrBpm,
    required this.sourceApp,
    required this.sourceDevice,
  });

  final DateTime sessionStart;
  final DateTime sessionEnd;
  final List<SleepStageSpan> stages;
  final double? hrAvgBpm;
  final double? hrvAvgMs;
  final double? restingHrBpm;
  final String? sourceApp;
  final String? sourceDevice;

  int get totalMinutes => sessionEnd.difference(sessionStart).inMinutes;

  String? get stagesJson =>
      stages.isEmpty ? null : jsonEncode(stages.map((s) => s.toJson()).toList());

  static List<SleepStageSpan> stagesFromJson(String? raw) {
    if (raw == null || raw.isEmpty) return const [];
    final list = jsonDecode(raw) as List;
    return list
        .map((e) => SleepStageSpan.fromJson(e as Map<String, dynamic>))
        .toList();
  }
}
```

- [ ] **Step 4: Run tests, verify they pass**

Run: `flutter test test/services/health/models_test.dart`
Expected: PASS, 3 tests passing.

- [ ] **Step 5: Commit**

```bash
git add lib/services/health/models.dart test/services/health/models_test.dart
git commit -m "feat(health): add SleepStage, SleepRecord, SleepStageSpan domain models"
```

---

### Task 3: Add `SleepRecords` Drift table

**Files:**
- Create: `lib/data/db/tables/sleep_records.dart`

- [ ] **Step 1: Create the table definition**

Create `lib/data/db/tables/sleep_records.dart`:

```dart
import 'package:drift/drift.dart';

class SleepRecords extends Table {
  IntColumn get id => integer().autoIncrement()();
  DateTimeColumn get sessionStart => dateTime()();
  DateTimeColumn get sessionEnd => dateTime()();
  IntColumn get totalMinutes => integer()();
  TextColumn get stagesJson => text().nullable()();
  RealColumn get hrAvgBpm => real().nullable()();
  RealColumn get hrvAvgMs => real().nullable()();
  RealColumn get restingHrBpm => real().nullable()();
  TextColumn get sourceApp => text().nullable()();
  TextColumn get sourceDevice => text().nullable()();
  DateTimeColumn get syncedAt =>
      dateTime().withDefault(currentDateAndTime)();

  @override
  List<Set<Column>> get uniqueKeys => [
        {sessionStart},
      ];
}
```

- [ ] **Step 2: Commit**

```bash
git add lib/data/db/tables/sleep_records.dart
git commit -m "feat(db): add SleepRecords table definition"
```

---

### Task 4: Register table in database + write migration v3 → v4

**Files:**
- Modify: `lib/data/db/database.dart`

- [ ] **Step 1: Update database.dart**

Replace the contents of `lib/data/db/database.dart` with:

```dart
import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';

import 'tables/caffeine_logs.dart';
import 'tables/cbti_weeks.dart';
import 'tables/sleep_diary_entries.dart';
import 'tables/sleep_records.dart';
import 'tables/user_schedule.dart';
import 'tables/worry_journal_entries.dart';

part 'database.g.dart';

@DriftDatabase(
  tables: [
    SleepDiaryEntries,
    UserSchedules,
    CbtiWeeks,
    CaffeineLogs,
    WorryJournalEntries,
    SleepRecords,
  ],
)
class NoctosDatabase extends _$NoctosDatabase {
  NoctosDatabase([QueryExecutor? executor])
    : super(
        executor ??
            driftDatabase(
              name: 'noctos',
              web: DriftWebOptions(
                sqlite3Wasm: Uri.parse('sqlite3.wasm'),
                driftWorker: Uri.parse('drift_worker.js'),
              ),
            ),
      );

  @override
  int get schemaVersion => 4;

  @override
  MigrationStrategy get migration => MigrationStrategy(
    onUpgrade: (m, from, to) async {
      if (from < 2) {
        await m.createTable(cbtiWeeks);
      }
      if (from < 3) {
        await m.createTable(caffeineLogs);
        await m.createTable(worryJournalEntries);
      }
      if (from < 4) {
        await m.createTable(sleepRecords);
      }
    },
  );
}
```

- [ ] **Step 2: Run codegen**

Run: `dart run build_runner build --delete-conflicting-outputs`
Expected: `Succeeded`, regenerates `database.g.dart` with `$SleepRecordsTable`.

- [ ] **Step 3: Run existing tests to confirm migration works**

Run: `flutter test`
Expected: All existing tests still pass (32 tests).

- [ ] **Step 4: Commit**

```bash
git add lib/data/db/database.dart lib/data/db/database.g.dart
git commit -m "feat(db): register SleepRecords table, schema v3 -> v4 migration"
```

---

### Task 5: Create `SleepRecordRepository`

**Files:**
- Create: `lib/data/repositories/sleep_record_repository.dart`
- Test: `test/data/repositories/sleep_record_repository_test.dart`

- [ ] **Step 1: Write failing tests**

Create `test/data/repositories/sleep_record_repository_test.dart`:

```dart
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:noctos/data/db/database.dart';
import 'package:noctos/data/repositories/sleep_record_repository.dart';
import 'package:noctos/services/health/models.dart';

SleepRecord makeRecord(DateTime start, {Duration duration = const Duration(hours: 7)}) {
  final end = start.add(duration);
  return SleepRecord(
    sessionStart: start,
    sessionEnd: end,
    stages: const [],
    hrAvgBpm: 58,
    hrvAvgMs: 42,
    restingHrBpm: 54,
    sourceApp: 'Mi Fitness',
    sourceDevice: 'Mi Band 7',
  );
}

void main() {
  late NoctosDatabase db;
  late SleepRecordRepository repo;

  setUp(() {
    db = NoctosDatabase(NativeDatabase.memory());
    repo = SleepRecordRepository(db);
  });

  tearDown(() async {
    await db.close();
  });

  test('upsert inserts new record', () async {
    await repo.upsertByNaturalKey(makeRecord(DateTime.utc(2026, 5, 26, 23, 30)));
    final all = await repo.all();
    expect(all, hasLength(1));
    expect(all.first.hrAvgBpm, 58);
  });

  test('upsert updates existing record with same sessionStart', () async {
    final start = DateTime.utc(2026, 5, 26, 23, 30);
    await repo.upsertByNaturalKey(makeRecord(start));
    final updated = SleepRecord(
      sessionStart: start,
      sessionEnd: start.add(const Duration(hours: 8)),
      stages: const [],
      hrAvgBpm: 60,
      hrvAvgMs: 40,
      restingHrBpm: 55,
      sourceApp: 'Mi Fitness',
      sourceDevice: 'Mi Band 7',
    );
    await repo.upsertByNaturalKey(updated);
    final all = await repo.all();
    expect(all, hasLength(1));
    expect(all.first.hrAvgBpm, 60);
    expect(all.first.totalMinutes, 8 * 60);
  });

  test('forNight returns record whose sessionStart falls between bedtime window', () async {
    await repo.upsertByNaturalKey(
      makeRecord(DateTime.utc(2026, 5, 26, 23, 30)),
    );
    final found = await repo.forNight(DateTime.utc(2026, 5, 27));
    expect(found, isNotNull);
    expect(found!.sessionStart, DateTime.utc(2026, 5, 26, 23, 30));
  });

  test('forNight returns null when no record overlaps', () async {
    final found = await repo.forNight(DateTime.utc(2026, 5, 27));
    expect(found, isNull);
  });

  test('lastSyncedSessionEnd returns max sessionEnd', () async {
    await repo.upsertByNaturalKey(
      makeRecord(DateTime.utc(2026, 5, 24, 23, 30)),
    );
    await repo.upsertByNaturalKey(
      makeRecord(DateTime.utc(2026, 5, 25, 23, 0)),
    );
    final latest = await repo.lastSyncedSessionEnd();
    expect(latest, DateTime.utc(2026, 5, 26, 6, 0));
  });

  test('lastSyncedSessionEnd returns null when empty', () async {
    expect(await repo.lastSyncedSessionEnd(), isNull);
  });
}
```

- [ ] **Step 2: Run tests, verify they fail**

Run: `flutter test test/data/repositories/sleep_record_repository_test.dart`
Expected: FAIL — package URI does not exist.

- [ ] **Step 3: Implement repository**

Create `lib/data/repositories/sleep_record_repository.dart`:

```dart
import 'package:drift/drift.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../services/health/models.dart';
import '../db/database.dart';
import '../db/db_providers.dart';

class SleepRecordRepository {
  SleepRecordRepository(this._db);
  final NoctosDatabase _db;

  Future<void> upsertByNaturalKey(SleepRecord r) async {
    await _db.into(_db.sleepRecords).insertOnConflictUpdate(
          SleepRecordsCompanion.insert(
            sessionStart: r.sessionStart,
            sessionEnd: r.sessionEnd,
            totalMinutes: r.totalMinutes,
            stagesJson: Value(r.stagesJson),
            hrAvgBpm: Value(r.hrAvgBpm),
            hrvAvgMs: Value(r.hrvAvgMs),
            restingHrBpm: Value(r.restingHrBpm),
            sourceApp: Value(r.sourceApp),
            sourceDevice: Value(r.sourceDevice),
          ),
        );
  }

  Future<List<SleepRecordRow>> all() {
    return (_db.select(_db.sleepRecords)
          ..orderBy([(t) => OrderingTerm.desc(t.sessionStart)]))
        .get();
  }

  /// Returns the sleep session whose start falls within the night
  /// preceding [diaryDate]. We define the night as
  /// `[diaryDate - 18h, diaryDate + 6h)` — wide enough to catch evening
  /// bedtimes and morning wake-ups while indexing on the wake-day.
  Future<SleepRecordRow?> forNight(DateTime diaryDate) async {
    final windowStart = diaryDate.subtract(const Duration(hours: 18));
    final windowEnd = diaryDate.add(const Duration(hours: 6));
    final q = _db.select(_db.sleepRecords)
      ..where((t) =>
          t.sessionStart.isBiggerOrEqualValue(windowStart) &
          t.sessionStart.isSmallerThanValue(windowEnd))
      ..orderBy([(t) => OrderingTerm.desc(t.totalMinutes)])
      ..limit(1);
    final rows = await q.get();
    return rows.isEmpty ? null : rows.first;
  }

  Stream<SleepRecordRow?> watchForNight(DateTime diaryDate) {
    final windowStart = diaryDate.subtract(const Duration(hours: 18));
    final windowEnd = diaryDate.add(const Duration(hours: 6));
    final q = _db.select(_db.sleepRecords)
      ..where((t) =>
          t.sessionStart.isBiggerOrEqualValue(windowStart) &
          t.sessionStart.isSmallerThanValue(windowEnd))
      ..orderBy([(t) => OrderingTerm.desc(t.totalMinutes)])
      ..limit(1);
    return q.watch().map((rows) => rows.isEmpty ? null : rows.first);
  }

  Future<DateTime?> lastSyncedSessionEnd() async {
    final maxExpr = _db.sleepRecords.sessionEnd.max();
    final row = await (_db.selectOnly(_db.sleepRecords)..addColumns([maxExpr]))
        .getSingleOrNull();
    return row?.read(maxExpr);
  }
}

typedef SleepRecordRow = SleepRecord$;
// NOTE: After codegen, Drift generates `SleepRecord` as the row class.
// Since our domain DTO is also called SleepRecord, we alias the
// generated class via `SleepRecord$`. If Drift names the generated
// class differently, replace `SleepRecord$` with the actual generated name.
```

**Note**: Drift's generated row class for table `SleepRecords` is named `SleepRecord` by default — collides with our domain DTO. Resolve by either:
- (a) Renaming the table class to `SleepRecordsTable` (Drift then generates `SleepRecordRow`), OR
- (b) Renaming the domain DTO to `HealthSleepRecord`.

Choose (b) — less invasive to existing code patterns. Proceed in the next step.

- [ ] **Step 4: Resolve naming collision — rename domain DTO**

Edit `lib/services/health/models.dart`: rename `class SleepRecord` to `class HealthSleepRecord` and update all references. Then update `test/services/health/models_test.dart` similarly.

```dart
// In models.dart:
class HealthSleepRecord { ... }
// In models_test.dart:
final record = HealthSleepRecord( ... );
```

In `lib/data/repositories/sleep_record_repository.dart`, change parameter type:
```dart
Future<void> upsertByNaturalKey(HealthSleepRecord r) async { ... }
```

Remove the `SleepRecordRow` typedef and `NOTE` comment — use the generated `SleepRecord` directly.

```dart
// Returns rows of the generated Drift row class `SleepRecord`.
Future<List<SleepRecord>> all() { ... }
Future<SleepRecord?> forNight(DateTime diaryDate) async { ... }
Stream<SleepRecord?> watchForNight(DateTime diaryDate) { ... }
```

In `test/data/repositories/sleep_record_repository_test.dart`, update import and helper:
```dart
HealthSleepRecord makeRecord(DateTime start, ...) {
  return HealthSleepRecord( ... );
}
```

- [ ] **Step 5: Run tests, verify they pass**

Run: `flutter test test/data/repositories/sleep_record_repository_test.dart test/services/health/models_test.dart`
Expected: PASS, all tests green.

- [ ] **Step 6: Add Riverpod provider at bottom of `sleep_record_repository.dart`**

```dart
final sleepRecordRepositoryProvider = Provider<SleepRecordRepository>((ref) {
  return SleepRecordRepository(ref.watch(databaseProvider));
});

final sleepRecordForNightProvider =
    StreamProvider.family<SleepRecord?, DateTime>((ref, diaryDate) {
  return ref.watch(sleepRecordRepositoryProvider).watchForNight(diaryDate);
});
```

- [ ] **Step 7: Run full suite**

Run: `flutter test && flutter analyze lib/ test/`
Expected: All pass, no analyzer warnings.

- [ ] **Step 8: Commit**

```bash
git add lib/data/repositories/sleep_record_repository.dart \
        lib/services/health/models.dart \
        test/data/repositories/sleep_record_repository_test.dart \
        test/services/health/models_test.dart
git commit -m "feat(health): SleepRecordRepository with upsert, forNight, lastSyncedSessionEnd"
```

---

## Phase 2 — Android Manifest + HC Service

### Task 6: Android manifest — permissions, queries, activity-alias

**Files:**
- Modify: `android/app/src/main/AndroidManifest.xml`

- [ ] **Step 1: Read existing manifest to find insertion points**

Run: `cat android/app/src/main/AndroidManifest.xml`
Identify the `<manifest>` root and the `<application>` block.

- [ ] **Step 2: Add 4 permissions inside `<manifest>` (outside `<application>`)**

Insert these at the manifest root level, before `<application>`:

```xml
<uses-permission android:name="android.permission.health.READ_SLEEP" />
<uses-permission android:name="android.permission.health.READ_HEART_RATE" />
<uses-permission android:name="android.permission.health.READ_HEART_RATE_VARIABILITY" />
<uses-permission android:name="android.permission.health.READ_RESTING_HEART_RATE" />

<queries>
  <package android:name="com.google.android.apps.healthdata" />
  <intent>
    <action android:name="androidx.health.ACTION_SHOW_PERMISSIONS_RATIONALE" />
  </intent>
</queries>
```

- [ ] **Step 3: Add activity-alias inside `<application>`**

Inside the `<application>` block (after the main `<activity>`), insert:

```xml
<activity-alias
    android:name="ViewPermissionUsageActivity"
    android:exported="true"
    android:targetActivity=".MainActivity"
    android:permission="android.permission.START_VIEW_PERMISSION_USAGE">
  <intent-filter>
    <action android:name="android.intent.action.VIEW_PERMISSION_USAGE" />
    <category android:name="android.intent.category.HEALTH_PERMISSIONS" />
  </intent-filter>
</activity-alias>
```

- [ ] **Step 4: Build an Android APK to verify manifest parses**

Run: `flutter build apk --debug`
Expected: Build succeeds. If it fails on manifest merger, fix the XML and rebuild.

- [ ] **Step 5: Commit**

```bash
git add android/app/src/main/AndroidManifest.xml
git commit -m "feat(android): Health Connect permissions, queries, activity-alias"
```

---

### Task 7: `HealthConnectService` — availability, permissions, raw reads

**Files:**
- Create: `lib/services/health/health_connect_service.dart`
- Create: `lib/services/health/providers.dart`

- [ ] **Step 1: Create the service**

Create `lib/services/health/health_connect_service.dart`:

```dart
import 'dart:io' show Platform;

import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:health/health.dart';

import 'models.dart';

enum HealthConnectStatus {
  unsupportedPlatform,
  notInstalled,
  available,
  needsPermissions,
  granted,
  partial,
  denied,
  error,
}

/// Wraps the `health` pub package so the rest of the app can be tested
/// against a fake [HealthConnectService] via Riverpod overrides.
abstract class HealthConnectService {
  Future<HealthConnectStatus> status();
  Future<HealthConnectStatus> requestPermissions();
  Future<List<HealthSleepRecord>> readSleepSessions(
      DateTime start, DateTime end);
  Future<void> openHealthConnectSettings();
}

class RealHealthConnectService implements HealthConnectService {
  RealHealthConnectService() : _health = Health() {
    _health.configure();
  }

  final Health _health;

  static const _readTypes = [
    HealthDataType.SLEEP_ASLEEP,
    HealthDataType.SLEEP_AWAKE,
    HealthDataType.SLEEP_DEEP,
    HealthDataType.SLEEP_LIGHT,
    HealthDataType.SLEEP_REM,
    HealthDataType.SLEEP_OUT_OF_BED,
    HealthDataType.SLEEP_SESSION,
    HealthDataType.HEART_RATE,
    HealthDataType.HEART_RATE_VARIABILITY_RMSSD,
    HealthDataType.RESTING_HEART_RATE,
  ];

  static const _readPermissions = [
    HealthDataAccess.READ,
    HealthDataAccess.READ,
    HealthDataAccess.READ,
    HealthDataAccess.READ,
    HealthDataAccess.READ,
    HealthDataAccess.READ,
    HealthDataAccess.READ,
    HealthDataAccess.READ,
    HealthDataAccess.READ,
    HealthDataAccess.READ,
  ];

  @override
  Future<HealthConnectStatus> status() async {
    if (kIsWeb || !Platform.isAndroid) {
      return HealthConnectStatus.unsupportedPlatform;
    }
    final sdkStatus = await _health.getHealthConnectSdkStatus();
    if (sdkStatus != HealthConnectSdkStatus.sdkAvailable) {
      return HealthConnectStatus.notInstalled;
    }
    final granted = await _health.hasPermissions(
          _readTypes,
          permissions: _readPermissions,
        ) ??
        false;
    if (granted) return HealthConnectStatus.granted;
    return HealthConnectStatus.needsPermissions;
  }

  @override
  Future<HealthConnectStatus> requestPermissions() async {
    if (kIsWeb || !Platform.isAndroid) {
      return HealthConnectStatus.unsupportedPlatform;
    }
    final ok = await _health.requestAuthorization(
      _readTypes,
      permissions: _readPermissions,
    );
    if (!ok) return HealthConnectStatus.denied;
    return status();
  }

  @override
  Future<List<HealthSleepRecord>> readSleepSessions(
      DateTime start, DateTime end) async {
    final raw = await _health.getHealthDataFromTypes(
      startTime: start,
      endTime: end,
      types: _readTypes,
    );
    return _foldIntoSessions(raw, start, end);
  }

  @override
  Future<void> openHealthConnectSettings() async {
    await _health.installHealthConnect();
  }

  /// Groups raw `HealthDataPoint`s into one [HealthSleepRecord] per
  /// `SLEEP_SESSION`. Heart-rate / HRV / resting-HR samples falling
  /// within each session window are averaged in.
  List<HealthSleepRecord> _foldIntoSessions(
    List<HealthDataPoint> points,
    DateTime windowStart,
    DateTime windowEnd,
  ) {
    final sessions = points
        .where((p) => p.type == HealthDataType.SLEEP_SESSION)
        .toList()
      ..sort((a, b) => a.dateFrom.compareTo(b.dateFrom));

    return sessions.map((session) {
      final start = session.dateFrom;
      final end = session.dateTo.isAfter(DateTime.now())
          ? DateTime.now()
          : session.dateTo;

      final stages = points
          .where((p) =>
              _isStageType(p.type) &&
              !p.dateFrom.isBefore(start) &&
              !p.dateTo.isAfter(end))
          .map((p) => SleepStageSpan(
                start: p.dateFrom,
                end: p.dateTo,
                stage: _stageFromType(p.type),
              ))
          .toList();

      final hrSamples = points
          .where((p) =>
              p.type == HealthDataType.HEART_RATE &&
              !p.dateFrom.isBefore(start) &&
              !p.dateFrom.isAfter(end))
          .map((p) => (p.value as NumericHealthValue).numericValue.toDouble())
          .toList();

      final hrvSamples = points
          .where((p) =>
              p.type == HealthDataType.HEART_RATE_VARIABILITY_RMSSD &&
              !p.dateFrom.isBefore(start) &&
              !p.dateFrom.isAfter(end))
          .map((p) => (p.value as NumericHealthValue).numericValue.toDouble())
          .toList();

      final restingHrSamples = points
          .where((p) =>
              p.type == HealthDataType.RESTING_HEART_RATE &&
              !p.dateFrom.isBefore(end.subtract(const Duration(hours: 24))))
          .map((p) => (p.value as NumericHealthValue).numericValue.toDouble())
          .toList();

      double? avg(List<double> xs) =>
          xs.isEmpty ? null : xs.reduce((a, b) => a + b) / xs.length;

      return HealthSleepRecord(
        sessionStart: start,
        sessionEnd: end,
        stages: stages,
        hrAvgBpm: avg(hrSamples),
        hrvAvgMs: avg(hrvSamples),
        restingHrBpm: avg(restingHrSamples),
        sourceApp: session.sourceName,
        sourceDevice: session.sourceDeviceId,
      );
    }).toList();
  }

  bool _isStageType(HealthDataType t) =>
      t == HealthDataType.SLEEP_AWAKE ||
      t == HealthDataType.SLEEP_LIGHT ||
      t == HealthDataType.SLEEP_DEEP ||
      t == HealthDataType.SLEEP_REM ||
      t == HealthDataType.SLEEP_OUT_OF_BED;

  SleepStage _stageFromType(HealthDataType t) {
    switch (t) {
      case HealthDataType.SLEEP_AWAKE:
        return SleepStage.awake;
      case HealthDataType.SLEEP_LIGHT:
        return SleepStage.light;
      case HealthDataType.SLEEP_DEEP:
        return SleepStage.deep;
      case HealthDataType.SLEEP_REM:
        return SleepStage.rem;
      case HealthDataType.SLEEP_OUT_OF_BED:
        return SleepStage.outOfBed;
      default:
        return SleepStage.unknown;
    }
  }
}
```

- [ ] **Step 2: Create Riverpod providers file**

Create `lib/services/health/providers.dart`:

```dart
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'health_connect_service.dart';

final healthConnectServiceProvider = Provider<HealthConnectService>((ref) {
  return RealHealthConnectService();
});

final healthConnectStatusProvider = FutureProvider<HealthConnectStatus>((ref) {
  return ref.watch(healthConnectServiceProvider).status();
});
```

- [ ] **Step 3: Verify it compiles**

Run: `flutter analyze lib/`
Expected: No errors. If the `health` package's API differs from the assumed names (e.g., `HealthDataType.SLEEP_SESSION` not present), check `https://pub.dev/documentation/health/latest/` and adjust enum names. Document any change inline.

- [ ] **Step 4: Commit**

```bash
git add lib/services/health/health_connect_service.dart lib/services/health/providers.dart
git commit -m "feat(health): HealthConnectService wrapper around health pkg"
```

---

### Task 8: `SleepRecordSync` orchestrator

**Files:**
- Create: `lib/services/health/sleep_record_sync.dart`
- Test: `test/services/health/sleep_record_sync_test.dart`

- [ ] **Step 1: Write failing tests using a fake HC service**

Create `test/services/health/sleep_record_sync_test.dart`:

```dart
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:noctos/data/db/database.dart';
import 'package:noctos/data/repositories/sleep_record_repository.dart';
import 'package:noctos/services/health/health_connect_service.dart';
import 'package:noctos/services/health/models.dart';
import 'package:noctos/services/health/sleep_record_sync.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FakeHealthConnectService implements HealthConnectService {
  FakeHealthConnectService({
    this.statusValue = HealthConnectStatus.granted,
    this.sessions = const [],
  });

  HealthConnectStatus statusValue;
  List<HealthSleepRecord> sessions;
  int readCalls = 0;

  @override
  Future<HealthConnectStatus> status() async => statusValue;
  @override
  Future<HealthConnectStatus> requestPermissions() async => statusValue;
  @override
  Future<List<HealthSleepRecord>> readSleepSessions(
      DateTime start, DateTime end) async {
    readCalls++;
    return sessions
        .where((s) =>
            !s.sessionStart.isBefore(start) && !s.sessionStart.isAfter(end))
        .toList();
  }

  @override
  Future<void> openHealthConnectSettings() async {}
}

void main() {
  late NoctosDatabase db;
  late SleepRecordRepository repo;

  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    db = NoctosDatabase(NativeDatabase.memory());
    repo = SleepRecordRepository(db);
  });

  tearDown(() async {
    await db.close();
  });

  test('no-op when HC not granted', () async {
    final svc = FakeHealthConnectService(
      statusValue: HealthConnectStatus.needsPermissions,
    );
    final sync = SleepRecordSync(svc, repo);
    await sync.syncRecent();
    expect(svc.readCalls, 0);
  });

  test('first connect: stores firstConnectedAt, no backfill', () async {
    final past = HealthSleepRecord(
      sessionStart: DateTime.now().subtract(const Duration(days: 3)),
      sessionEnd: DateTime.now().subtract(const Duration(days: 3, hours: -7)),
      stages: const [],
      hrAvgBpm: 58,
      hrvAvgMs: 42,
      restingHrBpm: 54,
      sourceApp: null,
      sourceDevice: null,
    );
    final svc = FakeHealthConnectService(sessions: [past]);
    final sync = SleepRecordSync(svc, repo);
    await sync.syncRecent();
    final all = await repo.all();
    expect(all, isEmpty,
        reason: 'going-forward-only — past session must not be ingested');
  });

  test('throttles repeated calls within 60s', () async {
    final svc = FakeHealthConnectService();
    final sync = SleepRecordSync(svc, repo);
    await sync.syncRecent();
    final firstCalls = svc.readCalls;
    await sync.syncRecent();
    expect(svc.readCalls, firstCalls,
        reason: 'second call within 60s should be throttled');
  });

  test('forceSync bypasses throttle', () async {
    final svc = FakeHealthConnectService();
    final sync = SleepRecordSync(svc, repo);
    await sync.syncRecent();
    await sync.syncRecent(force: true);
    expect(svc.readCalls, 2);
  });

  test('clamps future-dated sessionEnd to now()', () async {
    final future = DateTime.now().add(const Duration(hours: 2));
    final session = HealthSleepRecord(
      sessionStart: DateTime.now().subtract(const Duration(hours: 5)),
      sessionEnd: future,
      stages: const [],
      hrAvgBpm: null,
      hrvAvgMs: null,
      restingHrBpm: null,
      sourceApp: null,
      sourceDevice: null,
    );
    // Simulate prior connect so going-forward floor doesn't block.
    SharedPreferences.setMockInitialValues({
      'health.firstConnectedAt':
          DateTime.now().subtract(const Duration(days: 30)).toIso8601String(),
    });
    final svc = FakeHealthConnectService(sessions: [session]);
    final sync = SleepRecordSync(svc, repo);
    await sync.syncRecent();
    final all = await repo.all();
    expect(all, hasLength(1));
    expect(
      all.first.sessionEnd.isAfter(DateTime.now()),
      isFalse,
      reason: 'future timestamps must be clamped',
    );
  });

  test('dedups identical sessionStart on repeat sync', () async {
    SharedPreferences.setMockInitialValues({
      'health.firstConnectedAt':
          DateTime.now().subtract(const Duration(days: 30)).toIso8601String(),
    });
    final session = HealthSleepRecord(
      sessionStart: DateTime.now().subtract(const Duration(hours: 8)),
      sessionEnd: DateTime.now().subtract(const Duration(hours: 1)),
      stages: const [],
      hrAvgBpm: 60,
      hrvAvgMs: null,
      restingHrBpm: null,
      sourceApp: null,
      sourceDevice: null,
    );
    final svc = FakeHealthConnectService(sessions: [session]);
    final sync = SleepRecordSync(svc, repo);
    await sync.syncRecent();
    await sync.syncRecent(force: true);
    final all = await repo.all();
    expect(all, hasLength(1));
  });
}
```

- [ ] **Step 2: Run tests, verify they fail**

Run: `flutter test test/services/health/sleep_record_sync_test.dart`
Expected: FAIL — `package:noctos/services/health/sleep_record_sync.dart` not found.

- [ ] **Step 3: Implement the sync orchestrator**

Create `lib/services/health/sleep_record_sync.dart`:

```dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../data/repositories/sleep_record_repository.dart';
import 'health_connect_service.dart';
import 'models.dart';
import 'providers.dart';

class SleepRecordSync {
  SleepRecordSync(this._svc, this._repo);

  final HealthConnectService _svc;
  final SleepRecordRepository _repo;

  static const _firstConnectedKey = 'health.firstConnectedAt';
  static const _lastAttemptKey = 'health.lastSyncAttemptAt';
  static const _throttle = Duration(seconds: 60);
  static const _maxCatchup = Duration(days: 7);

  Future<void> syncRecent({bool force = false}) async {
    final status = await _svc.status();
    if (status != HealthConnectStatus.granted &&
        status != HealthConnectStatus.partial) {
      return;
    }

    final prefs = await SharedPreferences.getInstance();

    if (!force) {
      final lastAttemptIso = prefs.getString(_lastAttemptKey);
      if (lastAttemptIso != null) {
        final last = DateTime.parse(lastAttemptIso);
        if (DateTime.now().difference(last) < _throttle) {
          return;
        }
      }
    }

    var firstConnectedIso = prefs.getString(_firstConnectedKey);
    if (firstConnectedIso == null) {
      firstConnectedIso = DateTime.now().toIso8601String();
      await prefs.setString(_firstConnectedKey, firstConnectedIso);
    }
    final firstConnected = DateTime.parse(firstConnectedIso);

    await prefs.setString(_lastAttemptKey, DateTime.now().toIso8601String());

    final lastSyncedEnd = await _repo.lastSyncedSessionEnd();
    final now = DateTime.now();

    final candidates = <DateTime>[
      lastSyncedEnd ?? firstConnected,
      firstConnected,
      now.subtract(_maxCatchup),
    ];
    final windowStart =
        candidates.reduce((a, b) => a.isAfter(b) ? a : b);

    if (!windowStart.isBefore(now)) return;

    final sessions = await _svc.readSleepSessions(windowStart, now);

    for (final s in sessions) {
      final clampedEnd = s.sessionEnd.isAfter(now) ? now : s.sessionEnd;
      final clamped = HealthSleepRecord(
        sessionStart: s.sessionStart,
        sessionEnd: clampedEnd,
        stages: s.stages,
        hrAvgBpm: s.hrAvgBpm,
        hrvAvgMs: s.hrvAvgMs,
        restingHrBpm: s.restingHrBpm,
        sourceApp: s.sourceApp,
        sourceDevice: s.sourceDevice,
      );
      await _repo.upsertByNaturalKey(clamped);
    }
  }
}

final sleepRecordSyncProvider = Provider<SleepRecordSync>((ref) {
  return SleepRecordSync(
    ref.watch(healthConnectServiceProvider),
    ref.watch(sleepRecordRepositoryProvider),
  );
});
```

- [ ] **Step 4: Run tests, verify they pass**

Run: `flutter test test/services/health/sleep_record_sync_test.dart`
Expected: PASS, 6 tests passing.

- [ ] **Step 5: Run full suite**

Run: `flutter test`
Expected: All pass.

- [ ] **Step 6: Commit**

```bash
git add lib/services/health/sleep_record_sync.dart \
        test/services/health/sleep_record_sync_test.dart
git commit -m "feat(health): SleepRecordSync with throttle, going-forward floor, clamping"
```

---

## Phase 3 — UI: Settings + Rationale + Week-2 Nudge

### Task 9: Rationale sheet widget

**Files:**
- Create: `lib/features/settings/widgets/health_connect_rationale_sheet.dart`

- [ ] **Step 1: Create the widget**

```dart
import 'package:flutter/material.dart';

class HealthConnectRationaleSheet extends StatelessWidget {
  const HealthConnectRationaleSheet({super.key});

  /// Returns true if user tapped Continue, false if Cancel/dismiss.
  static Future<bool> show(BuildContext context) async {
    final result = await showModalBottomSheet<bool>(
      context: context,
      isScrollControlled: true,
      builder: (_) => const HealthConnectRationaleSheet(),
    );
    return result ?? false;
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Connect Health Connect',
                style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 12),
            const Text('noctos will read:'),
            const SizedBox(height: 8),
            const _Bullet('Sleep sessions (start, end, stages)'),
            const _Bullet('Heart rate during sleep'),
            const _Bullet('HRV (RMSSD)'),
            const _Bullet('Resting heart rate'),
            const SizedBox(height: 16),
            const Text(
              'Data stays on this device. noctos has no servers, '
              'no telemetry, no analytics.',
            ),
            const SizedBox(height: 8),
            const Text(
              'Watch data is informational only. Your diary entries '
              'drive the CBT-I program.',
              style: TextStyle(fontStyle: FontStyle.italic),
            ),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(false),
                  child: const Text('Cancel'),
                ),
                const SizedBox(width: 8),
                FilledButton(
                  onPressed: () => Navigator.of(context).pop(true),
                  child: const Text('Continue'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _Bullet extends StatelessWidget {
  const _Bullet(this.text);
  final String text;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('• '),
          Expanded(child: Text(text)),
        ],
      ),
    );
  }
}
```

- [ ] **Step 2: Verify it compiles**

Run: `flutter analyze lib/features/settings/widgets/`
Expected: No errors.

- [ ] **Step 3: Commit**

```bash
git add lib/features/settings/widgets/health_connect_rationale_sheet.dart
git commit -m "feat(settings): Health Connect rationale bottom sheet"
```

---

### Task 10: `HealthConnectSection` settings widget

**Files:**
- Create: `lib/features/settings/widgets/health_connect_section.dart`
- Test: `test/features/settings/health_connect_section_test.dart`

- [ ] **Step 1: Write failing widget test**

Create `test/features/settings/health_connect_section_test.dart`:

```dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:noctos/features/settings/widgets/health_connect_section.dart';
import 'package:noctos/services/health/health_connect_service.dart';
import 'package:noctos/services/health/models.dart';
import 'package:noctos/services/health/providers.dart';

class StubService implements HealthConnectService {
  StubService(this._status);
  HealthConnectStatus _status;
  @override
  Future<HealthConnectStatus> status() async => _status;
  @override
  Future<HealthConnectStatus> requestPermissions() async {
    _status = HealthConnectStatus.granted;
    return _status;
  }
  @override
  Future<List<HealthSleepRecord>> readSleepSessions(
          DateTime s, DateTime e) async =>
      const [];
  @override
  Future<void> openHealthConnectSettings() async {}
}

Widget wrap(HealthConnectStatus status) {
  return ProviderScope(
    overrides: [
      healthConnectServiceProvider.overrideWithValue(StubService(status)),
    ],
    child: const MaterialApp(
      home: Scaffold(body: HealthConnectSection()),
    ),
  );
}

void main() {
  testWidgets('shows "Not installed" when HC missing', (tester) async {
    await tester.pumpWidget(wrap(HealthConnectStatus.notInstalled));
    await tester.pumpAndSettle();
    expect(find.text('Health Connect not installed'), findsOneWidget);
    expect(find.text('Install from Play Store'), findsOneWidget);
  });

  testWidgets('shows Connect button when needs permissions',
      (tester) async {
    await tester.pumpWidget(wrap(HealthConnectStatus.needsPermissions));
    await tester.pumpAndSettle();
    expect(find.text('Connect'), findsOneWidget);
  });

  testWidgets('shows Connected + Sync now + Disconnect when granted',
      (tester) async {
    await tester.pumpWidget(wrap(HealthConnectStatus.granted));
    await tester.pumpAndSettle();
    expect(find.textContaining('Connected'), findsOneWidget);
    expect(find.text('Sync now'), findsOneWidget);
    expect(find.text('Disconnect'), findsOneWidget);
  });

  testWidgets('shows "Limited" chip when partial', (tester) async {
    await tester.pumpWidget(wrap(HealthConnectStatus.partial));
    await tester.pumpAndSettle();
    expect(find.text('Limited'), findsOneWidget);
  });

  testWidgets('shows "Unsupported on this platform" when not Android',
      (tester) async {
    await tester.pumpWidget(wrap(HealthConnectStatus.unsupportedPlatform));
    await tester.pumpAndSettle();
    expect(
      find.textContaining('Available on Android'),
      findsOneWidget,
    );
  });
}
```

- [ ] **Step 2: Run test, verify failure**

Run: `flutter test test/features/settings/health_connect_section_test.dart`
Expected: FAIL — section file does not exist.

- [ ] **Step 3: Implement the section widget**

Create `lib/features/settings/widgets/health_connect_section.dart`:

```dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../services/health/health_connect_service.dart';
import '../../../services/health/providers.dart';
import '../../../services/health/sleep_record_sync.dart';
import 'health_connect_rationale_sheet.dart';

class HealthConnectSection extends ConsumerWidget {
  const HealthConnectSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final statusAsync = ref.watch(healthConnectStatusProvider);
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Health Connect',
                style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 8),
            statusAsync.when(
              loading: () => const LinearProgressIndicator(),
              error: (e, _) => Text('Error: $e'),
              data: (status) => _body(context, ref, status),
            ),
          ],
        ),
      ),
    );
  }

  Widget _body(BuildContext context, WidgetRef ref, HealthConnectStatus s) {
    switch (s) {
      case HealthConnectStatus.unsupportedPlatform:
        return const Text('Available on Android only.');
      case HealthConnectStatus.notInstalled:
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Health Connect not installed'),
            const SizedBox(height: 8),
            FilledButton(
              onPressed: () => ref
                  .read(healthConnectServiceProvider)
                  .openHealthConnectSettings(),
              child: const Text('Install from Play Store'),
            ),
          ],
        );
      case HealthConnectStatus.needsPermissions:
      case HealthConnectStatus.denied:
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Not connected'),
            const SizedBox(height: 8),
            FilledButton(
              onPressed: () => _connect(context, ref),
              child: const Text('Connect'),
            ),
          ],
        );
      case HealthConnectStatus.granted:
      case HealthConnectStatus.partial:
      case HealthConnectStatus.available:
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.check_circle, size: 18),
                const SizedBox(width: 6),
                const Text('Connected'),
                if (s == HealthConnectStatus.partial) ...[
                  const SizedBox(width: 8),
                  const Chip(label: Text('Limited')),
                ],
              ],
            ),
            const SizedBox(height: 8),
            const Text('Reading: sleep, heart rate, HRV, resting HR'),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              children: [
                OutlinedButton(
                  onPressed: () =>
                      ref.read(sleepRecordSyncProvider).syncRecent(force: true),
                  child: const Text('Sync now'),
                ),
                TextButton(
                  onPressed: () => ref
                      .read(healthConnectServiceProvider)
                      .openHealthConnectSettings(),
                  child: const Text('Disconnect'),
                ),
              ],
            ),
          ],
        );
      case HealthConnectStatus.error:
        return const Text('Error reading Health Connect status.');
    }
  }

  Future<void> _connect(BuildContext context, WidgetRef ref) async {
    final proceed = await HealthConnectRationaleSheet.show(context);
    if (!proceed) return;
    await ref.read(healthConnectServiceProvider).requestPermissions();
    ref.invalidate(healthConnectStatusProvider);
  }
}
```

- [ ] **Step 4: Run tests, verify they pass**

Run: `flutter test test/features/settings/health_connect_section_test.dart`
Expected: PASS, 5 widget tests passing.

- [ ] **Step 5: Commit**

```bash
git add lib/features/settings/widgets/health_connect_section.dart \
        test/features/settings/health_connect_section_test.dart
git commit -m "feat(settings): HealthConnectSection widget with all status states"
```

---

### Task 11: Wire HC section into settings screen

**Files:**
- Modify: `lib/features/settings/settings_screen.dart`

- [ ] **Step 1: Read existing settings screen**

Run: `cat lib/features/settings/settings_screen.dart`
Identify the main scaffold body and a sensible insertion point (top of the body column).

- [ ] **Step 2: Add import**

Add to the import block at the top:
```dart
import 'widgets/health_connect_section.dart';
```

- [ ] **Step 3: Insert `HealthConnectSection()` widget**

Insert into the settings body (top of the main column) inside a `Padding`:

```dart
Padding(
  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
  child: HealthConnectSection(),
),
```

- [ ] **Step 4: Run app on Android emulator, verify section renders**

Run: `flutter run -d <android-device-id>`
Manually navigate to Settings. Verify section appears with a status (likely "Health Connect not installed" on a clean emulator).

- [ ] **Step 5: Commit**

```bash
git add lib/features/settings/settings_screen.dart
git commit -m "feat(settings): wire Health Connect section into settings screen"
```

---

### Task 12: Week-2 nudge banner widget + dismissal persistence

**Files:**
- Create: `lib/features/diary/widgets/health_connect_nudge_banner.dart`
- Test: `test/features/diary/health_connect_nudge_banner_test.dart`

- [ ] **Step 1: Write failing widget test**

Create `test/features/diary/health_connect_nudge_banner_test.dart`:

```dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:noctos/features/diary/widgets/health_connect_nudge_banner.dart';
import 'package:noctos/services/health/health_connect_service.dart';
import 'package:noctos/services/health/models.dart';
import 'package:noctos/services/health/providers.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FakeSvc implements HealthConnectService {
  FakeSvc(this.statusValue);
  HealthConnectStatus statusValue;
  @override
  Future<HealthConnectStatus> status() async => statusValue;
  @override
  Future<HealthConnectStatus> requestPermissions() async => statusValue;
  @override
  Future<List<HealthSleepRecord>> readSleepSessions(
          DateTime s, DateTime e) async =>
      const [];
  @override
  Future<void> openHealthConnectSettings() async {}
}

Widget wrap({
  required int currentWeek,
  required HealthConnectStatus status,
}) {
  return ProviderScope(
    overrides: [
      healthConnectServiceProvider.overrideWithValue(FakeSvc(status)),
    ],
    child: MaterialApp(
      home: Scaffold(
        body: HealthConnectNudgeBanner(currentWeek: currentWeek),
      ),
    ),
  );
}

void main() {
  setUp(() => SharedPreferences.setMockInitialValues({}));

  testWidgets('hidden when currentWeek < 2', (tester) async {
    await tester.pumpWidget(
      wrap(currentWeek: 1, status: HealthConnectStatus.needsPermissions),
    );
    await tester.pumpAndSettle();
    expect(find.byType(Card), findsNothing);
  });

  testWidgets('hidden when HC already granted', (tester) async {
    await tester.pumpWidget(
      wrap(currentWeek: 2, status: HealthConnectStatus.granted),
    );
    await tester.pumpAndSettle();
    expect(find.byType(Card), findsNothing);
  });

  testWidgets('shows when week>=2 and not granted', (tester) async {
    await tester.pumpWidget(
      wrap(currentWeek: 2, status: HealthConnectStatus.needsPermissions),
    );
    await tester.pumpAndSettle();
    expect(find.text('Connect Health Connect'), findsOneWidget);
    expect(find.text('Not now'), findsOneWidget);
  });

  testWidgets('"Not now" dismisses and persists', (tester) async {
    await tester.pumpWidget(
      wrap(currentWeek: 2, status: HealthConnectStatus.needsPermissions),
    );
    await tester.pumpAndSettle();
    await tester.tap(find.text('Not now'));
    await tester.pumpAndSettle();
    expect(find.byType(Card), findsNothing);
    final prefs = await SharedPreferences.getInstance();
    expect(prefs.getString('health.nudgeShownAt'), isNotNull);
  });

  testWidgets('hidden if nudgeShownAt already set', (tester) async {
    SharedPreferences.setMockInitialValues({
      'health.nudgeShownAt': DateTime.now().toIso8601String(),
    });
    await tester.pumpWidget(
      wrap(currentWeek: 2, status: HealthConnectStatus.needsPermissions),
    );
    await tester.pumpAndSettle();
    expect(find.byType(Card), findsNothing);
  });
}
```

- [ ] **Step 2: Run test, verify failure**

Run: `flutter test test/features/diary/health_connect_nudge_banner_test.dart`
Expected: FAIL — widget file not found.

- [ ] **Step 3: Implement the banner**

Create `lib/features/diary/widgets/health_connect_nudge_banner.dart`:

```dart
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../services/health/health_connect_service.dart';
import '../../../services/health/providers.dart';
import '../../settings/widgets/health_connect_rationale_sheet.dart';

class HealthConnectNudgeBanner extends HookConsumerWidget {
  const HealthConnectNudgeBanner({super.key, required this.currentWeek});

  final int currentWeek;

  static const _shownKey = 'health.nudgeShownAt';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dismissedLocal = useState<bool>(false);
    final shouldShowAsync = useMemoized(() async {
      if (currentWeek < 2) return false;
      final status = await ref.read(healthConnectServiceProvider).status();
      if (status == HealthConnectStatus.granted ||
          status == HealthConnectStatus.partial ||
          status == HealthConnectStatus.unsupportedPlatform) {
        return false;
      }
      final prefs = await SharedPreferences.getInstance();
      return prefs.getString(_shownKey) == null;
    }, [currentWeek]);
    final snap = useFuture(shouldShowAsync);

    if (dismissedLocal.value) return const SizedBox.shrink();
    if (!snap.hasData || snap.data == false) return const SizedBox.shrink();

    return Card(
      margin: const EdgeInsets.fromLTRB(16, 8, 16, 0),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Curious how your sleep tracker lines up with your diary?',
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () async {
                    await _markShown();
                    dismissedLocal.value = true;
                  },
                  child: const Text('Not now'),
                ),
                const SizedBox(width: 8),
                FilledButton(
                  onPressed: () async {
                    final ok =
                        await HealthConnectRationaleSheet.show(context);
                    if (ok) {
                      await ref
                          .read(healthConnectServiceProvider)
                          .requestPermissions();
                      ref.invalidate(healthConnectStatusProvider);
                    }
                    await _markShown();
                    dismissedLocal.value = true;
                  },
                  child: const Text('Connect Health Connect'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _markShown() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_shownKey, DateTime.now().toIso8601String());
  }
}
```

- [ ] **Step 4: Run tests, verify they pass**

Run: `flutter test test/features/diary/health_connect_nudge_banner_test.dart`
Expected: PASS, 5 widget tests passing.

- [ ] **Step 5: Commit**

```bash
git add lib/features/diary/widgets/health_connect_nudge_banner.dart \
        test/features/diary/health_connect_nudge_banner_test.dart
git commit -m "feat(diary): Health Connect week-2 nudge banner with one-time dismissal"
```

---

## Phase 4 — UI: Diary Strip + Detail Screen

### Task 13: `SleepRecordStrip` widget

**Files:**
- Create: `lib/features/diary/widgets/sleep_record_strip.dart`
- Test: `test/features/diary/sleep_record_strip_test.dart`

- [ ] **Step 1: Write failing widget test**

Create `test/features/diary/sleep_record_strip_test.dart`:

```dart
import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:noctos/data/db/database.dart';
import 'package:noctos/data/db/db_providers.dart';
import 'package:noctos/data/repositories/sleep_record_repository.dart';
import 'package:noctos/features/diary/widgets/sleep_record_strip.dart';
import 'package:noctos/services/health/models.dart';

Widget wrap(NoctosDatabase db, DateTime diaryDate) {
  return ProviderScope(
    overrides: [databaseProvider.overrideWithValue(db)],
    child: MaterialApp(
      home: Scaffold(body: SleepRecordStrip(diaryDate: diaryDate)),
    ),
  );
}

void main() {
  late NoctosDatabase db;

  setUp(() {
    db = NoctosDatabase(NativeDatabase.memory());
  });

  tearDown(() async {
    await db.close();
  });

  testWidgets('renders nothing when no record exists', (tester) async {
    await tester.pumpWidget(wrap(db, DateTime.utc(2026, 5, 27)));
    await tester.pumpAndSettle();
    expect(find.byIcon(Icons.watch), findsNothing);
  });

  testWidgets('renders timing + source when record exists', (tester) async {
    final repo = SleepRecordRepository(db);
    await repo.upsertByNaturalKey(HealthSleepRecord(
      sessionStart: DateTime.utc(2026, 5, 26, 23, 42),
      sessionEnd: DateTime.utc(2026, 5, 27, 6, 8),
      stages: const [],
      hrAvgBpm: 58,
      hrvAvgMs: 42,
      restingHrBpm: 54,
      sourceApp: 'Mi Fitness',
      sourceDevice: 'Mi Band 7',
    ));
    await tester.pumpWidget(wrap(db, DateTime.utc(2026, 5, 27)));
    await tester.pumpAndSettle();
    expect(find.textContaining('6h'), findsOneWidget);
    expect(find.textContaining('Mi Band 7'), findsOneWidget);
  });
}
```

- [ ] **Step 2: Run, verify failure**

Run: `flutter test test/features/diary/sleep_record_strip_test.dart`
Expected: FAIL — widget file missing.

- [ ] **Step 3: Implement the strip**

Create `lib/features/diary/widgets/sleep_record_strip.dart`:

```dart
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../data/repositories/sleep_record_repository.dart';

class SleepRecordStrip extends ConsumerWidget {
  const SleepRecordStrip({super.key, required this.diaryDate});

  final DateTime diaryDate;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final async = ref.watch(sleepRecordForNightProvider(diaryDate));
    return async.when(
      loading: () => const SizedBox.shrink(),
      error: (_, __) => const SizedBox.shrink(),
      data: (record) {
        if (record == null) return const SizedBox.shrink();
        final fmt = DateFormat('h:mma');
        final hours = record.totalMinutes ~/ 60;
        final mins = record.totalMinutes % 60;
        final source = [record.sourceDevice, record.sourceApp]
            .where((s) => s != null && s.isNotEmpty)
            .join(' · ');
        return InkWell(
          onTap: () => Navigator.of(context).pushNamed(
            '/diary/${diaryDate.toIso8601String()}/sleep-record',
          ),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
            child: Row(
              children: [
                const Icon(Icons.watch, size: 16),
                const SizedBox(width: 8),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${fmt.format(record.sessionStart).toLowerCase()} → '
                        '${fmt.format(record.sessionEnd).toLowerCase()} · '
                        '${hours}h ${mins}m',
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                      if (source.isNotEmpty)
                        Text(
                          '$source · tap for detail',
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                    ],
                  ),
                ),
                const Icon(Icons.chevron_right, size: 18),
              ],
            ),
          ),
        );
      },
    );
  }
}
```

- [ ] **Step 4: Run tests, verify pass**

Run: `flutter test test/features/diary/sleep_record_strip_test.dart`
Expected: PASS, 2 widget tests passing.

- [ ] **Step 5: Commit**

```bash
git add lib/features/diary/widgets/sleep_record_strip.dart \
        test/features/diary/sleep_record_strip_test.dart
git commit -m "feat(diary): SleepRecordStrip widget shows watch data under diary entry"
```

---

### Task 14: `SleepRecordDetailScreen`

**Files:**
- Create: `lib/features/diary/sleep_record_detail_screen.dart`
- Test: `test/features/diary/sleep_record_detail_screen_test.dart`

- [ ] **Step 1: Write failing test**

Create `test/features/diary/sleep_record_detail_screen_test.dart`:

```dart
import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:noctos/data/db/database.dart';
import 'package:noctos/data/db/db_providers.dart';
import 'package:noctos/data/repositories/sleep_record_repository.dart';
import 'package:noctos/features/diary/sleep_record_detail_screen.dart';
import 'package:noctos/services/health/models.dart';

Widget wrap(NoctosDatabase db, DateTime date) => ProviderScope(
      overrides: [databaseProvider.overrideWithValue(db)],
      child: MaterialApp(
        home: SleepRecordDetailScreen(diaryDate: date),
      ),
    );

void main() {
  late NoctosDatabase db;
  setUp(() {
    db = NoctosDatabase(NativeDatabase.memory());
  });
  tearDown(() async {
    await db.close();
  });

  testWidgets('shows session timing + HR + HRV when full record', (tester) async {
    await SleepRecordRepository(db).upsertByNaturalKey(HealthSleepRecord(
      sessionStart: DateTime.utc(2026, 5, 26, 23, 42),
      sessionEnd: DateTime.utc(2026, 5, 27, 6, 8),
      stages: [
        SleepStageSpan(
          start: DateTime.utc(2026, 5, 26, 23, 42),
          end: DateTime.utc(2026, 5, 27, 0, 30),
          stage: SleepStage.light,
        ),
      ],
      hrAvgBpm: 58,
      hrvAvgMs: 42,
      restingHrBpm: 54,
      sourceApp: 'Mi Fitness',
      sourceDevice: 'Mi Band 7',
    ));
    await tester.pumpWidget(wrap(db, DateTime.utc(2026, 5, 27)));
    await tester.pumpAndSettle();
    expect(find.textContaining('Mi Band 7'), findsOneWidget);
    expect(find.textContaining('58'), findsOneWidget);
    expect(find.textContaining('42'), findsOneWidget);
    expect(find.textContaining('Diary drives program'), findsOneWidget);
  });

  testWidgets('hides HR row when null', (tester) async {
    await SleepRecordRepository(db).upsertByNaturalKey(HealthSleepRecord(
      sessionStart: DateTime.utc(2026, 5, 26, 23, 42),
      sessionEnd: DateTime.utc(2026, 5, 27, 6, 8),
      stages: const [],
      hrAvgBpm: null,
      hrvAvgMs: null,
      restingHrBpm: null,
      sourceApp: null,
      sourceDevice: null,
    ));
    await tester.pumpWidget(wrap(db, DateTime.utc(2026, 5, 27)));
    await tester.pumpAndSettle();
    expect(find.textContaining('Heart rate'), findsNothing);
  });
}
```

- [ ] **Step 2: Run, verify failure**

Run: `flutter test test/features/diary/sleep_record_detail_screen_test.dart`
Expected: FAIL — screen file missing.

- [ ] **Step 3: Implement the detail screen**

Create `lib/features/diary/sleep_record_detail_screen.dart`:

```dart
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';

import '../../data/repositories/sleep_record_repository.dart';
import '../../services/health/models.dart';

class SleepRecordDetailScreen extends ConsumerWidget {
  const SleepRecordDetailScreen({super.key, required this.diaryDate});

  final DateTime diaryDate;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final async = ref.watch(sleepRecordForNightProvider(diaryDate));
    final dateLabel = DateFormat('EEE d MMM').format(diaryDate);
    return Scaffold(
      appBar: AppBar(title: Text('$dateLabel · watch data')),
      body: async.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Error: $e')),
        data: (record) {
          if (record == null) {
            return const Center(child: Text('No watch data for this night.'));
          }
          return _Body(record: record);
        },
      ),
    );
  }
}

class _Body extends StatelessWidget {
  const _Body({required this.record});
  final dynamic record; // Drift SleepRecord row

  @override
  Widget build(BuildContext context) {
    final fmt = DateFormat('h:mma');
    final hours = (record.totalMinutes as int) ~/ 60;
    final mins = (record.totalMinutes as int) % 60;
    final stages = HealthSleepRecord.stagesFromJson(record.stagesJson as String?);
    final source = [record.sourceDevice, record.sourceApp]
        .where((s) => s != null && (s as String).isNotEmpty)
        .join(' via ');

    final children = <Widget>[
      _row(context, 'Session',
          '${fmt.format(record.sessionStart as DateTime).toLowerCase()} → '
          '${fmt.format(record.sessionEnd as DateTime).toLowerCase()} '
          '(${hours}h ${mins}m)'),
      if (source.isNotEmpty) _row(context, 'Source', source),
      if (stages.isNotEmpty) ...[
        const SizedBox(height: 16),
        Text('Stages', style: Theme.of(context).textTheme.titleSmall),
        const SizedBox(height: 8),
        _StageBand(stages: stages),
        const SizedBox(height: 8),
        _StageLegend(stages: stages),
      ],
      if (record.hrAvgBpm != null)
        _row(context, 'Heart rate',
            'avg ${(record.hrAvgBpm as double).round()} bpm'
            '${record.restingHrBpm != null ? " · resting ${(record.restingHrBpm as double).round()}" : ""}'),
      if (record.hrvAvgMs != null)
        _row(context, 'HRV (RMSSD)',
            '${(record.hrvAvgMs as double).round()} ms'),
      const SizedBox(height: 24),
      const Divider(),
      const Padding(
        padding: EdgeInsets.symmetric(vertical: 8),
        child: Text(
          'Watch data informational. Diary drives program.',
          style: TextStyle(fontStyle: FontStyle.italic),
        ),
      ),
    ];

    return ListView(
      padding: const EdgeInsets.all(16),
      children: children,
    );
  }

  Widget _row(BuildContext c, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 110,
            child: Text(label,
                style: Theme.of(c).textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    )),
          ),
          Expanded(child: Text(value)),
        ],
      ),
    );
  }
}

class _StageBand extends StatelessWidget {
  const _StageBand({required this.stages});
  final List<SleepStageSpan> stages;

  @override
  Widget build(BuildContext context) {
    final total = stages.fold<int>(
        0, (acc, s) => acc + s.duration.inMinutes);
    if (total == 0) return const SizedBox.shrink();
    return SizedBox(
      height: 16,
      child: Row(
        children: stages
            .map((s) => Expanded(
                  flex: s.duration.inMinutes,
                  child: Container(color: _colorFor(s.stage)),
                ))
            .toList(),
      ),
    );
  }

  static Color _colorFor(SleepStage s) {
    switch (s) {
      case SleepStage.awake:
        return Colors.orange;
      case SleepStage.light:
        return Colors.blueGrey;
      case SleepStage.deep:
        return Colors.indigo;
      case SleepStage.rem:
        return Colors.deepPurple;
      case SleepStage.outOfBed:
        return Colors.brown;
      case SleepStage.unknown:
        return Colors.grey;
    }
  }
}

class _StageLegend extends StatelessWidget {
  const _StageLegend({required this.stages});
  final List<SleepStageSpan> stages;

  @override
  Widget build(BuildContext context) {
    final byStage = <SleepStage, int>{};
    for (final s in stages) {
      byStage[s.stage] = (byStage[s.stage] ?? 0) + s.duration.inMinutes;
    }
    return Wrap(
      spacing: 12,
      runSpacing: 4,
      children: byStage.entries.map((e) {
        final h = e.value ~/ 60;
        final m = e.value % 60;
        return Row(mainAxisSize: MainAxisSize.min, children: [
          Container(
              width: 10, height: 10, color: _StageBand._colorFor(e.key)),
          const SizedBox(width: 4),
          Text(
              '${e.key.name} ${h > 0 ? "${h}h " : ""}${m}m'),
        ]);
      }).toList(),
    );
  }
}
```

- [ ] **Step 4: Run tests, verify pass**

Run: `flutter test test/features/diary/sleep_record_detail_screen_test.dart`
Expected: PASS, 2 widget tests passing.

- [ ] **Step 5: Commit**

```bash
git add lib/features/diary/sleep_record_detail_screen.dart \
        test/features/diary/sleep_record_detail_screen_test.dart
git commit -m "feat(diary): SleepRecordDetailScreen with stage band and HR/HRV rows"
```

---

### Task 15: Add `/diary/:date/sleep-record` route

**Files:**
- Modify: `lib/core/router/router.dart` (path may differ — check `lib/core/router/` directory)

- [ ] **Step 1: Locate router file**

Run: `ls lib/core/` and `grep -r "GoRoute\|GoRouter" lib/core/ lib/`
Identify the file defining routes.

- [ ] **Step 2: Add route**

In the router definition, add to the `routes:` list:

```dart
GoRoute(
  path: '/diary/:date/sleep-record',
  builder: (context, state) {
    final date = DateTime.parse(state.pathParameters['date']!);
    return SleepRecordDetailScreen(diaryDate: date);
  },
),
```

Add the import:
```dart
import '../../features/diary/sleep_record_detail_screen.dart';
```

- [ ] **Step 3: Update `SleepRecordStrip` to use go_router instead of Navigator**

In `lib/features/diary/widgets/sleep_record_strip.dart`, replace:
```dart
onTap: () => Navigator.of(context).pushNamed(
  '/diary/${diaryDate.toIso8601String()}/sleep-record',
),
```
with:
```dart
onTap: () => GoRouter.of(context).push(
  '/diary/${diaryDate.toIso8601String()}/sleep-record',
),
```
Add import: `import 'package:go_router/go_router.dart';`

- [ ] **Step 4: Run flutter analyze + tests**

Run: `flutter analyze lib/ test/ && flutter test`
Expected: All pass.

- [ ] **Step 5: Commit**

```bash
git add lib/core/router/router.dart lib/features/diary/widgets/sleep_record_strip.dart
git commit -m "feat(routing): /diary/:date/sleep-record route -> detail screen"
```

---

### Task 16: Wire `SleepRecordStrip` into home + history screens

**Files:**
- Modify: `lib/features/diary/home_screen.dart`
- Modify: `lib/features/diary/diary_history_screen.dart`

- [ ] **Step 1: Read both screens to find diary card render points**

Run: `cat lib/features/diary/home_screen.dart`
Identify where the diary card / entry is rendered. Insert the strip directly below it.

Run: `cat lib/features/diary/diary_history_screen.dart`
Identify the per-row render. Insert the strip below each row's content.

- [ ] **Step 2: Add import + strip to home_screen**

Add import:
```dart
import 'widgets/sleep_record_strip.dart';
```

Insert below the diary-entry card (replace the actual card-finishing block with the wrap below):
```dart
SleepRecordStrip(diaryDate: DateTime.now()),
```

- [ ] **Step 3: Add import + strip to diary_history_screen**

Same import. For each list row that represents a diary entry on date `entry.diaryDate`, add below it:
```dart
SleepRecordStrip(diaryDate: entry.diaryDate),
```

- [ ] **Step 4: Run app, verify strips render and tapping navigates to detail**

Run: `flutter run -d <android-device-id>`
Manually verify:
1. Strip is absent when no HC data exists
2. (After Health Connect is connected + a watch logs sleep) strip appears
3. Tap on strip → detail screen shows session

- [ ] **Step 5: Run tests + analyze**

Run: `flutter test && flutter analyze lib/ test/`
Expected: All pass.

- [ ] **Step 6: Commit**

```bash
git add lib/features/diary/home_screen.dart lib/features/diary/diary_history_screen.dart
git commit -m "feat(diary): wire SleepRecordStrip into home and history screens"
```

---

### Task 17: Wire week-2 nudge into home screen + sync trigger on init/resume

**Files:**
- Modify: `lib/features/diary/home_screen.dart`

- [ ] **Step 1: Find a hook for the user's current program week**

Run: `grep -rn "currentWeek\|weekIndex" lib/`
Identify the Riverpod provider that exposes the active CBT-I week. If absent, fall back to reading from `CbtiWeekRepository().latest()` — there should already be such a provider exposed near `lib/data/repositories/cbti_week_repository.dart`.

- [ ] **Step 2: Read existing screen + lifecycle**

If `home_screen.dart` is a `StatelessWidget` or `ConsumerWidget`, convert to `HookConsumerWidget` so it can use `useEffect` for the resume hook. Add imports:
```dart
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'widgets/health_connect_nudge_banner.dart';
import '../../services/health/sleep_record_sync.dart';
```

- [ ] **Step 3: Add sync trigger on init and on app resume**

Inside the build method, add:
```dart
useEffect(() {
  // Fire-and-forget initial sync
  Future.microtask(
      () => ref.read(sleepRecordSyncProvider).syncRecent());

  final observer = _ResumeObserver(
      onResume: () => ref.read(sleepRecordSyncProvider).syncRecent());
  WidgetsBinding.instance.addObserver(observer);
  return () => WidgetsBinding.instance.removeObserver(observer);
}, const []);
```

Add helper class at the bottom of the file:
```dart
class _ResumeObserver extends WidgetsBindingObserver {
  _ResumeObserver({required this.onResume});
  final VoidCallback onResume;

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) onResume();
  }
}
```

- [ ] **Step 4: Insert nudge banner above diary card**

Inside the body column, add `HealthConnectNudgeBanner(currentWeek: currentWeek)`. Wire `currentWeek` from whichever provider step 1 identified. Example:
```dart
final weekAsync = ref.watch(currentCbtiWeekProvider);
final currentWeek = weekAsync.maybeWhen(data: (w) => w?.weekIndex ?? 0, orElse: () => 0);
```

Adjust based on actual provider name discovered in step 1.

- [ ] **Step 5: Run flutter analyze + tests**

Run: `flutter analyze lib/ test/ && flutter test`
Expected: All pass.

- [ ] **Step 6: Manual verification on device**

Run: `flutter run -d <android-device-id>`
Verify:
1. Sync fires on screen open (check `adb logcat` or breakpoint)
2. Banner appears when on week 2+ and HC not connected
3. Dismissing banner persists across restarts

- [ ] **Step 7: Commit**

```bash
git add lib/features/diary/home_screen.dart
git commit -m "feat(diary): wire week-2 nudge banner + sync trigger on init/resume"
```

---

## Phase 5 — Integration Test + Docs

### Task 18: Integration test for connect flow

**Files:**
- Create: `integration_test/health_connect_flow_test.dart`

- [ ] **Step 1: Check whether `integration_test` is set up**

Run: `ls integration_test/ 2>/dev/null || echo "missing"`
If missing: add `integration_test` to `dev_dependencies`:
```yaml
dev_dependencies:
  integration_test:
    sdk: flutter
```
Then `flutter pub get`.

- [ ] **Step 2: Write integration test**

Create `integration_test/health_connect_flow_test.dart`:

```dart
import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:noctos/app.dart';
import 'package:noctos/data/db/database.dart';
import 'package:noctos/data/db/db_providers.dart';
import 'package:noctos/services/health/health_connect_service.dart';
import 'package:noctos/services/health/models.dart';
import 'package:noctos/services/health/providers.dart';
import 'package:shared_preferences/shared_preferences.dart';

class StubHC implements HealthConnectService {
  StubHC(this._status);
  HealthConnectStatus _status;
  @override
  Future<HealthConnectStatus> status() async => _status;
  @override
  Future<HealthConnectStatus> requestPermissions() async {
    _status = HealthConnectStatus.granted;
    return _status;
  }
  @override
  Future<List<HealthSleepRecord>> readSleepSessions(
          DateTime s, DateTime e) async =>
      const [];
  @override
  Future<void> openHealthConnectSettings() async {}
}

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('Settings → Connect → status flips to Connected',
      (tester) async {
    SharedPreferences.setMockInitialValues({});
    final db = NoctosDatabase(NativeDatabase.memory());
    final stub = StubHC(HealthConnectStatus.needsPermissions);

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          databaseProvider.overrideWithValue(db),
          healthConnectServiceProvider.overrideWithValue(stub),
        ],
        child: const NoctosApp(),
      ),
    );

    await tester.pumpAndSettle();
    // Navigate to Settings (route name will depend on actual router).
    // Adjust the navigation step if Settings isn't the initial tab.
    // ...
    expect(find.text('Connect'), findsOneWidget);
    await tester.tap(find.text('Connect'));
    await tester.pumpAndSettle();
    // Rationale sheet
    expect(find.text('Continue'), findsOneWidget);
    await tester.tap(find.text('Continue'));
    await tester.pumpAndSettle();
    expect(find.text('Sync now'), findsOneWidget);

    await db.close();
  });
}
```

- [ ] **Step 3: Run integration test on device**

Run: `flutter test integration_test/ -d <android-device-id>`
Expected: PASS. If navigation steps fail because of the actual router structure, adjust the navigation to match the app's real entry flow.

- [ ] **Step 4: Commit**

```bash
git add integration_test/health_connect_flow_test.dart pubspec.yaml pubspec.lock
git commit -m "test(health): integration test for Connect flow end-to-end"
```

---

### Task 19: Ethics doc

**Files:**
- Create: `docs/health-integration.md`

- [ ] **Step 1: Write the doc**

Create `docs/health-integration.md`:

```markdown
# Health Connect integration

## What we read
- Sleep sessions (start, end, stages)
- Heart rate samples during sleep
- HRV (RMSSD) samples during sleep
- Resting heart rate

## Where it goes
Local SQLite, same database as your diary. Never leaves device.
noctos has no servers, no telemetry, no analytics.

## Why diary, not watch, drives the program
CBT-I sleep-restriction titration is calibrated on self-reported
sleep diaries (Spielman et al., 1987; Edinger & Carney, 2014).
Actigraphy systematically overestimates sleep — wrist sensors
cannot distinguish quiet wakefulness from sleep. Treatment
fidelity requires diary data.

Watch data displayed alongside for your own reference.

## Disconnecting
Settings → Health Connect → Disconnect. Deeplinks to Health
Connect's own permission management. Revoking removes our
access; existing local records remain unless you also wipe
app data.
```

- [ ] **Step 2: Add a "Learn more" link from settings section**

In `lib/features/settings/widgets/health_connect_section.dart`, add a `TextButton` in the granted-state row:
```dart
TextButton(
  onPressed: () => /* open docs/health-integration.md via url_launcher
                      to https://noctos.app/docs/health-integration or
                      bundle as an asset and show in a screen.
                      Simplest v1: omit link, doc lives in repo only. */ null,
  child: const Text('Learn more'),
),
```

For v1, the doc lives in the repo. Skip the in-app link.

- [ ] **Step 3: Commit**

```bash
git add docs/health-integration.md
git commit -m "docs: Health Connect integration overview and ethics"
```

---

### Task 20: README update

**Files:**
- Modify: `README.md`

- [ ] **Step 1: Find features section in README**

Run: `grep -n "## " README.md`
Identify the Features section heading.

- [ ] **Step 2: Add paragraph**

Under the Features section, append:

```markdown
- **Health Connect (Android)** — optional. noctos can read sleep
  timing, stages, heart rate, HRV, and resting heart rate from
  Health Connect and display them alongside your diary. Watch
  data is purely informational; your diary still drives the CBT-I
  program. See [docs/health-integration.md](docs/health-integration.md).
```

- [ ] **Step 3: Commit**

```bash
git add README.md
git commit -m "docs(readme): mention Health Connect integration"
```

---

### Task 21: Manual device QA

Not a code task — execute at release time. Document checklist in the PR description, run through it on at least two devices.

- [ ] Pixel 8 + Mi Band 7 + Mi Fitness app → connect, log sleep, verify strip + detail appear next day
- [ ] Samsung Galaxy S24 + Galaxy Watch + Samsung Health → same flow
- [ ] Uninstall Health Connect app while noctos is open → verify graceful degrade
- [ ] Revoke permissions from Health Connect Settings → verify toggle flips off, strip disappears
- [ ] Airplane mode → verify HC reads still work (Health Connect is local)
- [ ] Verify `firstConnectedAt` floor: connect on day N, ensure no historical sessions show

---

## Self-Review Notes

This plan covers all spec sections:
- Data model (Task 3, 4)
- Repository (Task 5)
- HealthConnectService + permissions (Tasks 6, 7)
- Sync orchestrator with throttle + `firstConnectedAt` floor (Task 8)
- Rationale sheet (Task 9)
- Settings section (Tasks 10, 11)
- Week-2 nudge (Tasks 12, 17)
- Diary strip (Tasks 13, 16)
- Detail screen + stage band (Task 14)
- Routing (Task 15)
- Sync triggers (Task 17)
- Integration test (Task 18)
- Ethics doc (Task 19)
- README (Task 20)
- Manual QA (Task 21)

Type consistency:
- Domain DTO renamed `HealthSleepRecord` throughout (resolved Drift naming collision in Task 5 Step 4)
- Generated Drift row class `SleepRecord` used in repository read methods
- `HealthConnectStatus` enum shared across service, sync, settings, nudge, integration test
