import 'package:drift/drift.dart';

class CbtiWeeks extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get weekIndex => integer()();
  TextColumn get phaseId => text()();
  DateTimeColumn get startedOn => dateTime()();
  IntColumn get prescribedBedtimeMinutesOfDay => integer()();
  IntColumn get prescribedWakeMinutesOfDay => integer()();
  IntColumn get tibMinutes => integer()();
  RealColumn get efficiencyTarget => real().withDefault(const Constant(0.85))();
  TextColumn get rationale => text()();
  TextColumn get action => text()(); // seed | expand | contract | hold | floor
  TextColumn get status => text().withDefault(const Constant('active'))();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
}
