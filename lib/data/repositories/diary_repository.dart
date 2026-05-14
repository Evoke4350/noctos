import 'package:drift/drift.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../db/database.dart';
import '../db/db_providers.dart';

class DiaryRepository {
  DiaryRepository(this._db);
  final NoctosDatabase _db;

  Stream<List<SleepDiaryEntry>> watchAll() {
    return (_db.select(
      _db.sleepDiaryEntries,
    )..orderBy([(t) => OrderingTerm.desc(t.diaryDate)])).watch();
  }

  Future<int> insert(SleepDiaryEntriesCompanion entry) {
    return _db.into(_db.sleepDiaryEntries).insert(entry);
  }

  Future<List<SleepDiaryEntry>> last(int count) {
    return (_db.select(_db.sleepDiaryEntries)
          ..orderBy([(t) => OrderingTerm.desc(t.diaryDate)])
          ..limit(count))
        .get();
  }
}

final diaryRepositoryProvider = Provider<DiaryRepository>((ref) {
  return DiaryRepository(ref.watch(databaseProvider));
});

final diaryStreamProvider = StreamProvider<List<SleepDiaryEntry>>((ref) {
  return ref.watch(diaryRepositoryProvider).watchAll();
});
