import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';

import 'tables/caffeine_logs.dart';
import 'tables/cbti_weeks.dart';
import 'tables/sleep_diary_entries.dart';
import 'tables/sleep_records.dart';
import 'tables/user_schedule.dart';
import 'tables/worry_journal_entries.dart';

part 'database.g.dart';

@DriftDatabase(
  tables: [
    SleepDiaryEntries,
    UserSchedules,
    CbtiWeeks,
    CaffeineLogs,
    WorryJournalEntries,
    SleepRecords,
  ],
)
class NoctosDatabase extends _$NoctosDatabase {
  NoctosDatabase([QueryExecutor? executor])
    : super(
        executor ??
            driftDatabase(
              name: 'noctos',
              web: DriftWebOptions(
                sqlite3Wasm: Uri.parse('sqlite3.wasm'),
                driftWorker: Uri.parse('drift_worker.js'),
              ),
            ),
      );

  @override
  int get schemaVersion => 4;

  @override
  MigrationStrategy get migration => MigrationStrategy(
    onUpgrade: (m, from, to) async {
      if (from < 2) {
        await m.createTable(cbtiWeeks);
      }
      if (from < 3) {
        await m.createTable(caffeineLogs);
        await m.createTable(worryJournalEntries);
      }
      if (from < 4) {
        await m.createTable(sleepRecords);
      }
    },
  );
}
