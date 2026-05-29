import 'package:drift/drift.dart' show DatabaseConnection;
import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:noctos/data/db/database.dart';
import 'package:noctos/data/db/db_providers.dart';
import 'package:noctos/data/repositories/sleep_record_repository.dart';
import 'package:noctos/features/diary/sleep_record_detail_screen.dart';
import 'package:noctos/services/health/models.dart';

Widget wrap(NoctosDatabase db, DateTime date) => ProviderScope(
  overrides: [databaseProvider.overrideWithValue(db)],
  child: MaterialApp(home: SleepRecordDetailScreen(diaryDate: date)),
);

void main() {
  late NoctosDatabase db;
  setUp(() {
    db = NoctosDatabase(
      DatabaseConnection(
        NativeDatabase.memory(),
        closeStreamsSynchronously: true,
      ),
    );
  });
  tearDown(() async {
    await db.close();
  });

  testWidgets('shows session timing + HR + HRV when full record', (
    tester,
  ) async {
    await SleepRecordRepository(db).upsertByNaturalKey(
      HealthSleepRecord(
        sessionStart: DateTime.utc(2026, 5, 26, 23, 42),
        sessionEnd: DateTime.utc(2026, 5, 27, 6, 8),
        stages: [
          SleepStageSpan(
            start: DateTime.utc(2026, 5, 26, 23, 42),
            end: DateTime.utc(2026, 5, 27, 0, 30),
            stage: SleepStage.light,
          ),
        ],
        hrAvgBpm: 58,
        hrvAvgMs: 42,
        restingHrBpm: 54,
        sourceApp: 'Mi Fitness',
        sourceDevice: 'Mi Band 7',
      ),
    );
    await tester.pumpWidget(wrap(db, DateTime.utc(2026, 5, 27)));
    await tester.pumpAndSettle();
    expect(find.textContaining('Mi Band 7'), findsOneWidget);
    expect(find.textContaining('avg 58 bpm'), findsOneWidget);
    expect(find.text('42 ms'), findsOneWidget);
    expect(find.textContaining('Diary drives program'), findsOneWidget);
  });

  testWidgets('hides HR row when null', (tester) async {
    await SleepRecordRepository(db).upsertByNaturalKey(
      HealthSleepRecord(
        sessionStart: DateTime.utc(2026, 5, 26, 23, 42),
        sessionEnd: DateTime.utc(2026, 5, 27, 6, 8),
        stages: const [],
        hrAvgBpm: null,
        hrvAvgMs: null,
        restingHrBpm: null,
        sourceApp: null,
        sourceDevice: null,
      ),
    );
    await tester.pumpWidget(wrap(db, DateTime.utc(2026, 5, 27)));
    await tester.pumpAndSettle();
    expect(find.textContaining('Heart rate'), findsNothing);
  });
}
