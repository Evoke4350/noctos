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
    if (status != HealthConnectStatus.granted) {
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
