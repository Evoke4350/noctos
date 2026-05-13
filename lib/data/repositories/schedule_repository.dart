import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../db/database.dart';
import '../db/db_providers.dart';

class ScheduleRepository {
  ScheduleRepository(this._db);
  final NoctosDatabase _db;

  Stream<UserSchedule?> watch() {
    return (_db.select(_db.userSchedules)..limit(1))
        .watch()
        .map((rows) => rows.isEmpty ? null : rows.first);
  }

  Future<UserSchedule?> get() async {
    final rows = await (_db.select(_db.userSchedules)..limit(1)).get();
    return rows.isEmpty ? null : rows.first;
  }

  Future<int> create(UserSchedulesCompanion entry) {
    return _db.into(_db.userSchedules).insert(entry);
  }

  Future<void> update(UserSchedule updated) async {
    await _db.update(_db.userSchedules).replace(
          updated.copyWith(updatedAt: DateTime.now()),
        );
  }
}

final scheduleRepositoryProvider = Provider<ScheduleRepository>((ref) {
  return ScheduleRepository(ref.watch(databaseProvider));
});

final scheduleProvider = StreamProvider<UserSchedule?>((ref) {
  return ref.watch(scheduleRepositoryProvider).watch();
});
