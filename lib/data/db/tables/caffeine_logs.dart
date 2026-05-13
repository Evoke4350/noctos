import 'package:drift/drift.dart';

class CaffeineLogs extends Table {
  IntColumn get id => integer().autoIncrement()();
  DateTimeColumn get consumedAt => dateTime()();
  IntColumn get mg => integer()();
  TextColumn get source => text().nullable()();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
}
