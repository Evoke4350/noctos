import 'package:drift/drift.dart';

class SleepDiaryEntries extends Table {
  IntColumn get id => integer().autoIncrement()();
  DateTimeColumn get diaryDate => dateTime()();
  DateTimeColumn get bedtime => dateTime()();
  DateTimeColumn get lightsOut => dateTime()();
  IntColumn get sleepLatencyMin => integer().withDefault(const Constant(0))();
  IntColumn get awakeningsCount => integer().withDefault(const Constant(0))();
  IntColumn get wasoMin => integer().withDefault(const Constant(0))();
  DateTimeColumn get wakeTime => dateTime()();
  DateTimeColumn get outOfBedTime => dateTime()();
  IntColumn get qualityRating => integer().withDefault(const Constant(3))();
  IntColumn get moodRating => integer().withDefault(const Constant(3))();
  BoolColumn get adherentToPrescription =>
      boolean().withDefault(const Constant(true))();
  TextColumn get notes => text().nullable()();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
}
