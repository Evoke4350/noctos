import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:noctos/data/db/database.dart';
import 'package:noctos/data/db/db_providers.dart';
import 'package:noctos/data/repositories/sleep_record_repository.dart';
import 'package:noctos/features/diary/widgets/sleep_record_strip.dart';
import 'package:noctos/services/health/models.dart';

NoctosDatabase _makeDb() => NoctosDatabase(
  DatabaseConnection(NativeDatabase.memory(), closeStreamsSynchronously: true),
);

Widget wrap(NoctosDatabase db, DateTime diaryDate) {
  return ProviderScope(
    overrides: [databaseProvider.overrideWithValue(db)],
    child: MaterialApp(
      home: Scaffold(body: SleepRecordStrip(diaryDate: diaryDate)),
    ),
  );
}

void main() {
  late NoctosDatabase db;

  setUp(() {
    db = _makeDb();
  });

  tearDown(() async {
    await db.close();
  });

  testWidgets('renders nothing when no record exists', (tester) async {
    await tester.pumpWidget(wrap(db, DateTime.utc(2026, 5, 27)));
    await tester.pumpAndSettle();
    expect(find.byIcon(Icons.watch), findsNothing);
  });

  testWidgets('renders timing + source when record exists', (tester) async {
    final repo = SleepRecordRepository(db);
    await repo.upsertByNaturalKey(
      HealthSleepRecord(
        sessionStart: DateTime.utc(2026, 5, 26, 23, 42),
        sessionEnd: DateTime.utc(2026, 5, 27, 6, 8),
        stages: const [],
        hrAvgBpm: 58,
        hrvAvgMs: 42,
        restingHrBpm: 54,
        sourceApp: 'Mi Fitness',
        sourceDevice: 'Mi Band 7',
      ),
    );
    await tester.pumpWidget(wrap(db, DateTime.utc(2026, 5, 27)));
    await tester.pumpAndSettle();
    expect(find.textContaining('6h'), findsOneWidget);
    expect(find.textContaining('Mi Band 7'), findsOneWidget);
  });
}
