/// Sleep-restriction titration core.
///
/// Inputs are plain numbers so this file is fully testable without Flutter
/// or Drift. Callers convert from diary entries.

/// Single night used by the algorithm.
class NightSample {
  /// Time-in-bed (out_of_bed - bedtime), minutes.
  final int timeInBedMin;

  /// Total sleep time = TIB − latency − WASO, minutes.
  /// Caller must compute (cannot be negative).
  final int totalSleepMin;

  /// True if user followed the prescribed window. Non-adherent nights are
  /// excluded from rolling efficiency.
  final bool adherent;

  const NightSample({
    required this.timeInBedMin,
    required this.totalSleepMin,
    required this.adherent,
  });

  double get efficiency => timeInBedMin <= 0 ? 0 : totalSleepMin / timeInBedMin;
}

/// What the algorithm prescribes for the upcoming week.
class PrescribedWindow {
  /// Wake minute-of-day (0..1439). Anchored, does not move on titration.
  final int wakeMinutesOfDay;

  /// Bedtime minute-of-day (0..1439). Computed: wake − tib (wrapped).
  final int bedtimeMinutesOfDay;

  /// Total time-in-bed window, minutes. Always ≥ 300 (5h floor).
  final int tibMinutes;

  /// Human-readable explanation. Shown verbatim in UI.
  final String rationale;

  /// Action taken: 'seed', 'expand', 'contract', 'hold', 'floor'.
  final String action;

  const PrescribedWindow({
    required this.wakeMinutesOfDay,
    required this.bedtimeMinutesOfDay,
    required this.tibMinutes,
    required this.rationale,
    required this.action,
  });
}

/// Inputs needed to compute the next window.
class SleepRestrictionInput {
  /// Diary nights, newest first. Caller passes the last 7.
  final List<NightSample> recentEntries;

  /// Fixed wake time (minute-of-day). Anchor.
  final int fixedWakeMinutesOfDay;

  /// Currently-prescribed TIB. Null on first prescription (seeding).
  final int? currentTibMinutes;

  /// Natural cap on TIB (e.g. user's actual sleep need ceiling). Default 8h.
  final int naturalCapMinutes;

  /// Adjustment step (default 15 min).
  final int stepMinutes;

  /// Lower SE threshold. Below → contract.
  final double contractBelow;

  /// Upper SE threshold. At or above → expand.
  final double expandAtOrAbove;

  /// Minimum rolling-window of adherent nights required before titrating.
  /// Defaults to 5 (CBT-I standard).
  final int minAdherentForTitration;

  /// Floor on TIB. CBT-I never prescribes below 5h.
  final int floorMinutes;

  const SleepRestrictionInput({
    required this.recentEntries,
    required this.fixedWakeMinutesOfDay,
    this.currentTibMinutes,
    this.naturalCapMinutes = 480,
    this.stepMinutes = 15,
    this.contractBelow = 0.80,
    this.expandAtOrAbove = 0.85,
    this.minAdherentForTitration = 5,
    this.floorMinutes = 300,
  });
}

int _round15(num m) => ((m / 15).round()) * 15;

int _wrapMinutes(int m) {
  final mod = m % (24 * 60);
  return mod < 0 ? mod + 24 * 60 : mod;
}

PrescribedWindow computeNextSleepWindow(SleepRestrictionInput input) {
  final adherent = input.recentEntries.where((e) => e.adherent).toList();
  final n = adherent.length;

  // First-time prescription: seed from observed sleep, clamped.
  if (input.currentTibMinutes == null) {
    final tst = n == 0
        ? 420 // 7h fallback when no data
        : adherent.map((e) => e.totalSleepMin).reduce((a, b) => a + b) ~/ n;
    final seeded = _round15(tst).clamp(input.floorMinutes, input.naturalCapMinutes);
    return _build(
      input: input,
      tib: seeded,
      action: 'seed',
      rationale:
          'Initial prescription seeded from your reported sleep (${_fmt(tst)}). '
          'Floored at ${_fmt(input.floorMinutes)} and capped at ${_fmt(input.naturalCapMinutes)}.',
    );
  }

  final current = input.currentTibMinutes!;

  // Not enough adherent data to titrate — hold.
  if (n < input.minAdherentForTitration) {
    return _build(
      input: input,
      tib: current,
      action: 'hold',
      rationale:
          'Holding current window. Need ${input.minAdherentForTitration} adherent nights '
          'to titrate (have $n).',
    );
  }

  final tst = adherent.map((e) => e.totalSleepMin).reduce((a, b) => a + b) / n;
  final tib = adherent.map((e) => e.timeInBedMin).reduce((a, b) => a + b) / n;
  final se = tib <= 0 ? 0.0 : tst / tib;

  if (se >= input.expandAtOrAbove) {
    final next = (current + input.stepMinutes).clamp(input.floorMinutes, input.naturalCapMinutes);
    if (next == current) {
      return _build(
        input: input,
        tib: current,
        action: 'hold',
        rationale:
            'Efficiency ${(se * 100).toStringAsFixed(0)}% (target ≥ ${(input.expandAtOrAbove * 100).toStringAsFixed(0)}%) — would expand but cap of ${_fmt(input.naturalCapMinutes)} reached.',
      );
    }
    return _build(
      input: input,
      tib: next,
      action: 'expand',
      rationale:
          'Efficiency ${(se * 100).toStringAsFixed(0)}% (≥ ${(input.expandAtOrAbove * 100).toStringAsFixed(0)}%) — expanding window by ${input.stepMinutes} min.',
    );
  }

  if (se < input.contractBelow) {
    final raw = current - input.stepMinutes;
    if (raw < input.floorMinutes) {
      return _build(
        input: input,
        tib: input.floorMinutes,
        action: 'floor',
        rationale:
            'Efficiency ${(se * 100).toStringAsFixed(0)}% (< ${(input.contractBelow * 100).toStringAsFixed(0)}%) — would contract but ${_fmt(input.floorMinutes)} is the floor.',
      );
    }
    return _build(
      input: input,
      tib: raw,
      action: 'contract',
      rationale:
          'Efficiency ${(se * 100).toStringAsFixed(0)}% (< ${(input.contractBelow * 100).toStringAsFixed(0)}%) — contracting window by ${input.stepMinutes} min.',
    );
  }

  return _build(
    input: input,
    tib: current,
    action: 'hold',
    rationale:
        'Efficiency ${(se * 100).toStringAsFixed(0)}% — between ${(input.contractBelow * 100).toStringAsFixed(0)}% and ${(input.expandAtOrAbove * 100).toStringAsFixed(0)}%. Holding window.',
  );
}

PrescribedWindow _build({
  required SleepRestrictionInput input,
  required int tib,
  required String action,
  required String rationale,
}) {
  final bedtime = _wrapMinutes(input.fixedWakeMinutesOfDay - tib);
  return PrescribedWindow(
    wakeMinutesOfDay: input.fixedWakeMinutesOfDay,
    bedtimeMinutesOfDay: bedtime,
    tibMinutes: tib,
    rationale: rationale,
    action: action,
  );
}

String _fmt(int min) {
  final h = min ~/ 60;
  final m = min % 60;
  if (h == 0) return '${m}m';
  if (m == 0) return '${h}h';
  return '${h}h ${m}m';
}
