import 'package:drift/drift.dart';

class SleepRecords extends Table {
  IntColumn get id => integer().autoIncrement()();
  DateTimeColumn get sessionStart => dateTime()();
  DateTimeColumn get sessionEnd => dateTime()();
  IntColumn get totalMinutes => integer()();
  TextColumn get stagesJson => text().nullable()();
  RealColumn get hrAvgBpm => real().nullable()();
  RealColumn get hrvAvgMs => real().nullable()();
  RealColumn get restingHrBpm => real().nullable()();
  TextColumn get sourceApp => text().nullable()();
  TextColumn get sourceDevice => text().nullable()();
  DateTimeColumn get syncedAt => dateTime().withDefault(currentDateAndTime)();

  // One physical sleep session is identified by when it started AND which
  // source produced it. Keying on sessionStart alone made two sources for the
  // same night overwrite each other; including the source lets them coexist as
  // separate rows, and the read layer (forNight) picks the most-trusted.
  @override
  List<Set<Column>> get uniqueKeys => [
    {sessionStart, sourceApp, sourceDevice},
  ];
}
