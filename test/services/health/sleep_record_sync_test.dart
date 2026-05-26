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
  Future<void> installHealthConnectApp() async {}
  @override
  Future<void> revokePermissions() async {}
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
      sessionEnd: DateTime.now().subtract(const Duration(days: 3))
          .add(const Duration(hours: 7)),
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
