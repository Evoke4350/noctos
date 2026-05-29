import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:noctos/data/db/database.dart';
import 'package:noctos/data/repositories/sleep_record_repository.dart';
import 'package:noctos/services/health/models.dart';

HealthSleepRecord makeRecord(
  DateTime start, {
  Duration duration = const Duration(hours: 7),
}) {
  final end = start.add(duration);
  return HealthSleepRecord(
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

HealthSleepRecord rec(
  DateTime start, {
  Duration duration = const Duration(hours: 7),
  String? app = 'Mi Fitness',
  String? device = 'Mi Band 7',
  double? hrv = 42,
}) => HealthSleepRecord(
  sessionStart: start,
  sessionEnd: start.add(duration),
  stages: const [],
  hrAvgBpm: 58,
  hrvAvgMs: hrv,
  restingHrBpm: 54,
  sourceApp: app,
  sourceDevice: device,
);

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
    await repo.upsertByNaturalKey(
      makeRecord(DateTime.utc(2026, 5, 26, 23, 30)),
    );
    final all = await repo.all();
    expect(all, hasLength(1));
    expect(all.first.hrAvgBpm, 58);
  });

  test('upsert updates existing record with same sessionStart', () async {
    final start = DateTime.utc(2026, 5, 26, 23, 30);
    await repo.upsertByNaturalKey(makeRecord(start));
    final updated = HealthSleepRecord(
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

  test(
    'forNight returns record whose sessionStart falls in the night window',
    () async {
      await repo.upsertByNaturalKey(
        makeRecord(DateTime.utc(2026, 5, 26, 23, 30)),
      );
      final found = await repo.forNight(DateTime.utc(2026, 5, 27));
      expect(found, isNotNull);
      expect(found!.sessionStart, DateTime.utc(2026, 5, 26, 23, 30));
    },
  );

  test('forNight returns null when no record overlaps', () async {
    final found = await repo.forNight(DateTime.utc(2026, 5, 27));
    expect(found, isNull);
  });

  test('lastSyncedSessionEnd returns max sessionEnd', () async {
    await repo.upsertByNaturalKey(
      makeRecord(DateTime.utc(2026, 5, 24, 23, 30)),
    );
    await repo.upsertByNaturalKey(makeRecord(DateTime.utc(2026, 5, 25, 23, 0)));
    final latest = await repo.lastSyncedSessionEnd();
    expect(latest, DateTime.utc(2026, 5, 26, 6, 0));
  });

  test('lastSyncedSessionEnd returns null when empty', () async {
    expect(await repo.lastSyncedSessionEnd(), isNull);
  });

  test(
    'different sources for the same night are kept as separate rows',
    () async {
      final start = DateTime.utc(2026, 5, 26, 23, 30);
      await repo.upsertByNaturalKey(
        rec(start, app: 'Galaxy Wearable', device: 'Galaxy Watch6'),
      );
      await repo.upsertByNaturalKey(
        rec(start, app: 'Pixel', device: 'Pixel 8'),
      );
      final all = await repo.all();
      expect(
        all,
        hasLength(2),
        reason: 'distinct sources must not overwrite each other',
      );
    },
  );

  test(
    'null incoming field never clobbers a stored non-null on re-sync',
    () async {
      final start = DateTime.utc(2026, 5, 26, 23, 30);
      await repo.upsertByNaturalKey(rec(start, hrv: 42));
      await repo.upsertByNaturalKey(
        rec(start, hrv: null),
      ); // later sync, no HRV
      final all = await repo.all();
      expect(all, hasLength(1));
      expect(all.first.hrvAvgMs, 42, reason: 'null must not erase stored HRV');
    },
  );

  test(
    'forNight prefers the higher-trust source over the longer session',
    () async {
      await repo.upsertByNaturalKey(
        rec(
          DateTime.utc(2026, 5, 26, 23, 0),
          app: 'Pixel',
          device: 'Pixel 8',
          duration: const Duration(hours: 9),
        ),
      );
      await repo.upsertByNaturalKey(
        rec(
          DateTime.utc(2026, 5, 26, 23, 30),
          app: 'Galaxy Wearable',
          device: 'Galaxy Watch6',
          duration: const Duration(hours: 7),
        ),
      );
      final best = await repo.forNight(DateTime.utc(2026, 5, 27));
      expect(
        best!.sourceDevice,
        'Galaxy Watch6',
        reason: 'watch (trust 30) beats phone (trust 20) despite shorter sleep',
      );
    },
  );
}
