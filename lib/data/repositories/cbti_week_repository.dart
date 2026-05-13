import 'package:drift/drift.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../db/database.dart';
import '../db/db_providers.dart';

class CbtiWeekRepository {
  CbtiWeekRepository(this._db);
  final NoctosDatabase _db;

  Stream<List<CbtiWeek>> watchAll() {
    return (_db.select(_db.cbtiWeeks)
          ..orderBy([(t) => OrderingTerm.asc(t.createdAt)]))
        .watch();
  }

  Future<CbtiWeek?> latest() async {
    final rows = await (_db.select(_db.cbtiWeeks)
          ..orderBy([(t) => OrderingTerm.desc(t.id)])
          ..limit(1))
        .get();
    return rows.isEmpty ? null : rows.first;
  }

  Stream<CbtiWeek?> watchLatest() {
    return (_db.select(_db.cbtiWeeks)
          ..orderBy([(t) => OrderingTerm.desc(t.id)])
          ..limit(1))
        .watch()
        .map((rows) => rows.isEmpty ? null : rows.first);
  }

  Future<int> insert(CbtiWeeksCompanion entry) {
    return _db.into(_db.cbtiWeeks).insert(entry);
  }
}

final cbtiWeekRepositoryProvider = Provider<CbtiWeekRepository>((ref) {
  return CbtiWeekRepository(ref.watch(databaseProvider));
});

final cbtiWeeksStreamProvider = StreamProvider<List<CbtiWeek>>((ref) {
  return ref.watch(cbtiWeekRepositoryProvider).watchAll();
});

final currentCbtiWeekProvider = StreamProvider<CbtiWeek?>((ref) {
  return ref.watch(cbtiWeekRepositoryProvider).watchLatest();
});
