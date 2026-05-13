import 'package:drift/drift.dart' as drift;
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:noctos/data/db/database.dart';
import 'package:noctos/data/repositories/cbti_week_repository.dart';
import 'package:noctos/data/repositories/diary_repository.dart';
import 'package:noctos/data/repositories/schedule_repository.dart';
import 'package:noctos/domain/cbti/engine.dart';
import 'package:noctos/domain/cbti/protocol.dart';

Future<int> insertSchedule(NoctosDatabase db) async {
  return db.into(db.userSchedules).insert(UserSchedulesCompanion.insert(
        fixedWakeMinutesOfDay: 7 * 60,
        currentBedtimeMinutesOfDay: 23 * 60,
        currentTibMinutes: const drift.Value(480),
      ));
}

Future<void> insertNight(
  NoctosDatabase db, {
  required DateTime date,
  required int tibMin,
  required double efficiency,
  bool adherent = true,
}) async {
  final bedtime = date.subtract(Duration(minutes: tibMin));
  final tst = (tibMin * efficiency).round();
  final waso = tibMin - tst - 10; // 10 min latency assumed
  await db.into(db.sleepDiaryEntries).insert(SleepDiaryEntriesCompanion.insert(
        diaryDate: date,
        bedtime: bedtime,
        lightsOut: bedtime,
        wakeTime: date,
        outOfBedTime: date,
        sleepLatencyMin: const drift.Value(10),
        wasoMin: drift.Value(waso.clamp(0, tibMin)),
        adherentToPrescription: drift.Value(adherent),
      ));
}

void main() {
  late NoctosDatabase db;
  late CBTIEngine engine;

  setUp(() {
    db = NoctosDatabase(NativeDatabase.memory());
    engine = CBTIEngine(
      CbtiWeekRepository(db),
      DiaryRepository(db),
      ScheduleRepository(db),
    );
  });

  tearDown(() async {
    await db.close();
  });

  test('first diary insert creates assessment week with seeded prescription', () async {
    await insertSchedule(db);
    await insertNight(db, date: DateTime.now(), tibMin: 480, efficiency: 0.75);

    final id = await engine.onDiaryInserted();
    expect(id, isNotNull);

    final latest = await CbtiWeekRepository(db).latest();
    expect(latest, isNotNull);
    expect(latest!.phaseId, phaseId(CBTIPhase.assessment));
    expect(latest.action, 'seed');
    // 480 * 0.75 = 360, rounded to nearest 15 = 360, clamped [300, 480] = 360
    expect(latest.tibMinutes, 360);
    expect(latest.prescribedWakeMinutesOfDay, 7 * 60);
  });

  test('advances assessment → sr_baseline after 7 diary entries', () async {
    await insertSchedule(db);
    final base = DateTime.now();
    for (var i = 0; i < 7; i++) {
      await insertNight(
        db,
        date: base.subtract(Duration(days: 6 - i)),
        tibMin: 480,
        efficiency: 0.70,
      );
      await engine.onDiaryInserted();
    }
    final latest = await CbtiWeekRepository(db).latest();
    expect(latest!.phaseId, phaseId(CBTIPhase.srBaseline));
  });

  test('non-adherent nights excluded from prescription update', () async {
    await insertSchedule(db);
    // 5 adherent nights at 90% efficiency at TIB=360 → should expand
    final base = DateTime.now();
    for (var i = 0; i < 5; i++) {
      await insertNight(
        db,
        date: base.subtract(Duration(days: 4 - i)),
        tibMin: 360,
        efficiency: 0.90,
        adherent: true,
      );
    }
    // 2 non-adherent nights at terrible efficiency — these must be ignored.
    for (var i = 0; i < 2; i++) {
      await insertNight(
        db,
        date: base.add(Duration(days: i + 1)),
        tibMin: 480,
        efficiency: 0.30,
        adherent: false,
      );
    }
    // Seed the engine state with a prior week.
    await db.into(db.cbtiWeeks).insert(CbtiWeeksCompanion.insert(
          weekIndex: 1,
          phaseId: phaseId(CBTIPhase.srBaseline),
          startedOn: DateTime.now().subtract(const Duration(days: 1)),
          prescribedBedtimeMinutesOfDay: 1 * 60,
          prescribedWakeMinutesOfDay: 7 * 60,
          tibMinutes: 360,
          rationale: 'initial',
          action: 'seed',
        ));

    final id = await engine.onDiaryInserted();
    expect(id, isNotNull);
    final latest = await CbtiWeekRepository(db).latest();
    expect(latest!.action, 'expand');
    expect(latest.tibMinutes, 375);
  });

  test('schedule current TIB updated after prescription', () async {
    await insertSchedule(db);
    await insertNight(db, date: DateTime.now(), tibMin: 360, efficiency: 0.90);
    await engine.onDiaryInserted();

    final schedule = await ScheduleRepository(db).get();
    // First-ever entry → assessment phase, seeded prescription based on samples
    expect(schedule!.currentTibMinutes, isNot(equals(480)));
  });
}
