import 'package:drift/drift.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../services/health/models.dart';
import '../../services/health/source_trust.dart';
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

  /// Upserts one session keyed by (sessionStart, sourceApp, sourceDevice).
  ///
  /// On a re-sync of the same session from the same source, an incoming `null`
  /// field never overwrites a stored non-null value (null is "no data", not
  /// "data cleared"); a non-null incoming field always wins. Records from a
  /// *different* source for the same night are stored as separate rows — they
  /// are not merged here; [forNight] decides which one to surface.
  Future<void> upsertByNaturalKey(HealthSleepRecord r) async {
    final existing =
        await (_db.select(_db.sleepRecords)
              ..where(
                (t) =>
                    t.sessionStart.equals(r.sessionStart) &
                    _matchNullableText(t.sourceApp, r.sourceApp) &
                    _matchNullableText(t.sourceDevice, r.sourceDevice),
              )
              ..limit(1))
            .getSingleOrNull();

    if (existing == null) {
      await _db
          .into(_db.sleepRecords)
          .insert(
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
      return;
    }

    await (_db.update(
      _db.sleepRecords,
    )..where((t) => t.id.equals(existing.id))).write(
      SleepRecordsCompanion(
        sessionEnd: Value(r.sessionEnd),
        totalMinutes: Value(r.totalMinutes),
        stagesJson: Value(r.stagesJson ?? existing.stagesJson),
        hrAvgBpm: Value(r.hrAvgBpm ?? existing.hrAvgBpm),
        hrvAvgMs: Value(r.hrvAvgMs ?? existing.hrvAvgMs),
        restingHrBpm: Value(r.restingHrBpm ?? existing.restingHrBpm),
        syncedAt: Value(DateTime.now().toUtc()),
      ),
    );
  }

  Expression<bool> _matchNullableText(
    GeneratedColumn<String> col,
    String? value,
  ) => value == null ? col.isNull() : col.equals(value);

  /// Picks the best record among sources that wrote this night: highest source
  /// trust first, then longest session. Replaces the old "longest wins", which
  /// let a phone's loose in-bed window beat a watch's richer staged session.
  SleepRecord? _pickBest(List<SleepRecord> rows) {
    if (rows.isEmpty) return null;
    rows.sort((a, b) {
      final t = sourceTrust(
        b.sourceApp,
        b.sourceDevice,
      ).compareTo(sourceTrust(a.sourceApp, a.sourceDevice));
      return t != 0 ? t : b.totalMinutes.compareTo(a.totalMinutes);
    });
    return _toUtc(rows.first);
  }

  Future<List<SleepRecord>> all() async {
    final rows = await (_db.select(
      _db.sleepRecords,
    )..orderBy([(t) => OrderingTerm.desc(t.sessionStart)])).get();
    return rows.map(_toUtc).toList();
  }

  SimpleSelectStatement<$SleepRecordsTable, SleepRecord> _nightQuery(
    DateTime diaryDate,
  ) {
    final windowStart = diaryDate.subtract(const Duration(hours: 18));
    final windowEnd = diaryDate.add(const Duration(hours: 6));
    return _db.select(_db.sleepRecords)..where(
      (t) =>
          t.sessionStart.isBiggerOrEqualValue(windowStart) &
          t.sessionStart.isSmallerThanValue(windowEnd),
    );
  }

  Future<SleepRecord?> forNight(DateTime diaryDate) async =>
      _pickBest(await _nightQuery(diaryDate).get());

  Stream<SleepRecord?> watchForNight(DateTime diaryDate) =>
      _nightQuery(diaryDate).watch().map(_pickBest);

  Future<DateTime?> lastSyncedSessionEnd() async {
    final maxExpr = _db.sleepRecords.sessionEnd.max();
    final row = await (_db.selectOnly(
      _db.sleepRecords,
    )..addColumns([maxExpr])).getSingleOrNull();
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
