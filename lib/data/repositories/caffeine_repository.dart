import 'package:drift/drift.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../db/database.dart';
import '../db/db_providers.dart';

class CaffeineRepository {
  CaffeineRepository(this._db);
  final NoctosDatabase _db;

  Stream<List<CaffeineLog>> watchSince(DateTime since) {
    return (_db.select(_db.caffeineLogs)
          ..where((t) => t.consumedAt.isBiggerOrEqualValue(since))
          ..orderBy([(t) => OrderingTerm.desc(t.consumedAt)]))
        .watch();
  }

  Future<int> insert(DateTime consumedAt, int mg, String? source) {
    return _db
        .into(_db.caffeineLogs)
        .insert(
          CaffeineLogsCompanion.insert(
            consumedAt: consumedAt,
            mg: mg,
            source: Value(source),
          ),
        );
  }

  Future<int> delete(int id) {
    return (_db.delete(_db.caffeineLogs)..where((t) => t.id.equals(id))).go();
  }
}

final caffeineRepositoryProvider = Provider<CaffeineRepository>((ref) {
  return CaffeineRepository(ref.watch(databaseProvider));
});

final caffeineLast24hProvider = StreamProvider<List<CaffeineLog>>((ref) {
  final since = DateTime.now().subtract(const Duration(hours: 24));
  return ref.watch(caffeineRepositoryProvider).watchSince(since);
});
