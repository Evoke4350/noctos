import 'package:drift/drift.dart' as drift;
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/db/database.dart';
import '../../data/repositories/cbti_week_repository.dart';
import '../../data/repositories/diary_repository.dart';
import '../../data/repositories/schedule_repository.dart';
import 'protocol.dart';
import 'sleep_restriction.dart';

/// Coordinates the CBT-I program state machine: phase transitions and
/// sleep-restriction prescriptions. Append-only — new prescriptions
/// are new CbtiWeek rows, never mutations.
class CBTIEngine {
  CBTIEngine(this._weeks, this._diary, this._schedule);

  final CbtiWeekRepository _weeks;
  final DiaryRepository _diary;
  final ScheduleRepository _schedule;

  /// Recompute. Called whenever a diary entry is inserted.
  /// Returns the newly-created CbtiWeek row id if one was added, else null.
  Future<int?> onDiaryInserted() async {
    final schedule = await _schedule.get();
    if (schedule == null) return null;

    final entries = await _diary.last(14);
    final current = await _weeks.latest();

    final transition = _evaluatePhaseTransition(
      current: current,
      diaryCount: entries.length,
    );

    final samples = entries.map(_toSample).toList();

    final prescription = computeNextSleepWindow(SleepRestrictionInput(
      recentEntries: samples,
      fixedWakeMinutesOfDay: schedule.fixedWakeMinutesOfDay,
      currentTibMinutes: current?.tibMinutes,
    ));

    final shouldAppend = current == null ||
        transition.advancedTo != null ||
        prescription.action != 'hold';

    if (!shouldAppend) return null;

    final phase = transition.advancedTo ??
        (current == null ? CBTIPhase.assessment : phaseFromId(current.phaseId));

    final id = await _weeks.insert(CbtiWeeksCompanion.insert(
      weekIndex: specFor(phase).approxWeekIndex,
      phaseId: phaseId(phase),
      startedOn: DateTime.now(),
      prescribedBedtimeMinutesOfDay: prescription.bedtimeMinutesOfDay,
      prescribedWakeMinutesOfDay: prescription.wakeMinutesOfDay,
      tibMinutes: prescription.tibMinutes,
      rationale: prescription.rationale,
      action: prescription.action,
    ));

    await _schedule.update(schedule.copyWith(
      currentBedtimeMinutesOfDay: prescription.bedtimeMinutesOfDay,
      currentTibMinutes: prescription.tibMinutes,
      updatedAt: DateTime.now(),
    ));

    return id;
  }

  NightSample _toSample(SleepDiaryEntry e) {
    final tib = e.outOfBedTime.difference(e.bedtime).inMinutes;
    final tst = (tib - e.sleepLatencyMin - e.wasoMin).clamp(0, tib);
    return NightSample(
      timeInBedMin: tib,
      totalSleepMin: tst,
      adherent: e.adherentToPrescription,
    );
  }
}

class _Transition {
  final CBTIPhase? advancedTo;
  const _Transition(this.advancedTo);
}

_Transition _evaluatePhaseTransition({
  required CbtiWeek? current,
  required int diaryCount,
}) {
  if (current == null) {
    // First entry ever — enter assessment.
    return const _Transition(CBTIPhase.assessment);
  }
  final phase = phaseFromId(current.phaseId);
  final spec = specFor(phase);
  final daysIn = DateTime.now().difference(current.startedOn).inDays;

  switch (phase) {
    case CBTIPhase.assessment:
      if (diaryCount >= spec.minDays) return const _Transition(CBTIPhase.srBaseline);
      return const _Transition(null);
    case CBTIPhase.srBaseline:
      if (daysIn >= spec.minDays) return const _Transition(CBTIPhase.srActive);
      return const _Transition(null);
    case CBTIPhase.srActive:
      if (daysIn >= spec.minDays) return const _Transition(CBTIPhase.cognitive);
      return const _Transition(null);
    case CBTIPhase.cognitive:
      if (daysIn >= spec.minDays) return const _Transition(CBTIPhase.hygiene);
      return const _Transition(null);
    case CBTIPhase.hygiene:
      if (daysIn >= spec.minDays) return const _Transition(CBTIPhase.relapsePrevention);
      return const _Transition(null);
    case CBTIPhase.stimulusControl:
    case CBTIPhase.relapsePrevention:
      return const _Transition(null);
  }
}

final cbtiEngineProvider = Provider<CBTIEngine>((ref) {
  return CBTIEngine(
    ref.watch(cbtiWeekRepositoryProvider),
    ref.watch(diaryRepositoryProvider),
    ref.watch(scheduleRepositoryProvider),
  );
});
