import 'package:drift/drift.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../services/health/models.dart';
import '../db/database.dart';
import '../db/db_providers.dart';

SleepRecord _toUtc(SleepRecord r) => r.copyWith(
      sessionStart: r.sessionStart.toUtc(),
      sessionEnd: r.sessionEnd.toUtc(),
      syncedAt: r.syncedAt.toUtc(),
    );

class SleepRecordRepository {
  SleepRecordRepository(this._db);
  final NoctosDatabase _db;

  Future<void> upsertByNaturalKey(HealthSleepRecord r) async {
    final companion = SleepRecordsCompanion.insert(
      sessionStart: r.sessionStart,
      sessionEnd: r.sessionEnd,
      totalMinutes: r.totalMinutes,
      stagesJson: Value(r.stagesJson),
      hrAvgBpm: Value(r.hrAvgBpm),
      hrvAvgMs: Value(r.hrvAvgMs),
      restingHrBpm: Value(r.restingHrBpm),
      sourceApp: Value(r.sourceApp),
      sourceDevice: Value(r.sourceDevice),
    );
    await _db.into(_db.sleepRecords).insert(
          companion,
          onConflict: DoUpdate(
            (_) => companion,
            target: [_db.sleepRecords.sessionStart],
          ),
        );
  }

  Future<List<SleepRecord>> all() async {
    final rows = await (_db.select(_db.sleepRecords)
          ..orderBy([(t) => OrderingTerm.desc(t.sessionStart)]))
        .get();
    return rows.map(_toUtc).toList();
  }

  Future<SleepRecord?> forNight(DateTime diaryDate) async {
    final windowStart = diaryDate.subtract(const Duration(hours: 18));
    final windowEnd = diaryDate.add(const Duration(hours: 6));
    final q = _db.select(_db.sleepRecords)
      ..where((t) =>
          t.sessionStart.isBiggerOrEqualValue(windowStart) &
          t.sessionStart.isSmallerThanValue(windowEnd))
      ..orderBy([(t) => OrderingTerm.desc(t.totalMinutes)])
      ..limit(1);
    final rows = await q.get();
    return rows.isEmpty ? null : _toUtc(rows.first);
  }

  Stream<SleepRecord?> watchForNight(DateTime diaryDate) {
    final windowStart = diaryDate.subtract(const Duration(hours: 18));
    final windowEnd = diaryDate.add(const Duration(hours: 6));
    final q = _db.select(_db.sleepRecords)
      ..where((t) =>
          t.sessionStart.isBiggerOrEqualValue(windowStart) &
          t.sessionStart.isSmallerThanValue(windowEnd))
      ..orderBy([(t) => OrderingTerm.desc(t.totalMinutes)])
      ..limit(1);
    return q.watch().map((rows) => rows.isEmpty ? null : _toUtc(rows.first));
  }

  Future<DateTime?> lastSyncedSessionEnd() async {
    final maxExpr = _db.sleepRecords.sessionEnd.max();
    final row = await (_db.selectOnly(_db.sleepRecords)..addColumns([maxExpr]))
        .getSingleOrNull();
    return row?.read(maxExpr)?.toUtc();
  }
}

final sleepRecordRepositoryProvider = Provider<SleepRecordRepository>((ref) {
  return SleepRecordRepository(ref.watch(databaseProvider));
});

final sleepRecordForNightProvider =
    StreamProvider.family<SleepRecord?, DateTime>((ref, diaryDate) {
  return ref.watch(sleepRecordRepositoryProvider).watchForNight(diaryDate);
});
