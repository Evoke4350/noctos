import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';

import 'tables/sleep_diary_entries.dart';
import 'tables/user_schedule.dart';

part 'database.g.dart';

@DriftDatabase(tables: [SleepDiaryEntries, UserSchedules])
class NoctosDatabase extends _$NoctosDatabase {
  NoctosDatabase([QueryExecutor? executor])
      : super(executor ?? driftDatabase(name: 'noctos'));

  @override
  int get schemaVersion => 1;
}
