import 'package:drift/drift.dart';

class UserSchedules extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get fixedWakeMinutesOfDay => integer()();
  IntColumn get currentBedtimeMinutesOfDay => integer()();
  IntColumn get currentTibMinutes =>
      integer().withDefault(const Constant(450))();
  IntColumn get windDownMinutes => integer().withDefault(const Constant(30))();
  IntColumn get caffeineCutoffOffsetMin =>
      integer().withDefault(const Constant(600))();
  IntColumn get chronotypeScore => integer().nullable()();
  TextColumn get chronotypeCategory => text().nullable()();
  TextColumn get insomniaTypes => text().nullable()();
  IntColumn get insomniaSeverity => integer().nullable()();
  BoolColumn get notificationsEnabled =>
      boolean().withDefault(const Constant(true))();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();
}
