import 'package:drift/drift.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../db/database.dart';
import '../db/db_providers.dart';

class WorryRepository {
  WorryRepository(this._db);
  final NoctosDatabase _db;

  Stream<List<WorryJournalEntry>> watchAll() {
    return (_db.select(_db.worryJournalEntries)
          ..orderBy([(t) => OrderingTerm.desc(t.enteredAt)]))
        .watch();
  }

  Future<int> insert({
    required DateTime enteredAt,
    required String worry,
    String? nextAction,
  }) {
    return _db.into(_db.worryJournalEntries).insert(
          WorryJournalEntriesCompanion.insert(
            enteredAt: enteredAt,
            worry: worry,
            nextAction: Value(nextAction),
          ),
        );
  }

  Future<int> setResolved(int id, bool value) {
    return (_db.update(_db.worryJournalEntries)..where((t) => t.id.equals(id)))
        .write(WorryJournalEntriesCompanion(resolved: Value(value)));
  }

  Future<int> delete(int id) {
    return (_db.delete(_db.worryJournalEntries)..where((t) => t.id.equals(id))).go();
  }
}

final worryRepositoryProvider = Provider<WorryRepository>((ref) {
  return WorryRepository(ref.watch(databaseProvider));
});

final worryStreamProvider = StreamProvider<List<WorryJournalEntry>>((ref) {
  return ref.watch(worryRepositoryProvider).watchAll();
});
