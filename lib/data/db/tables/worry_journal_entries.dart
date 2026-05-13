import 'package:drift/drift.dart';

class WorryJournalEntries extends Table {
  IntColumn get id => integer().autoIncrement()();
  DateTimeColumn get enteredAt => dateTime()();
  TextColumn get worry => text()();
  TextColumn get nextAction => text().nullable()();
  BoolColumn get resolved => boolean().withDefault(const Constant(false))();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
}
