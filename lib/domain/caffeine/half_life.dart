import 'dart:math' as math;

/// Common sources and approximate mg. UI-only — algorithm operates on raw mg.
class CaffeineSource {
  final String label;
  final int mg;
  const CaffeineSource(this.label, this.mg);
}

const commonCaffeineSources = <CaffeineSource>[
  CaffeineSource('Espresso shot', 65),
  CaffeineSource('Drip coffee (8oz)', 95),
  CaffeineSource('Cold brew (16oz)', 200),
  CaffeineSource('Black tea (8oz)', 47),
  CaffeineSource('Green tea (8oz)', 28),
  CaffeineSource('Matcha (8oz)', 70),
  CaffeineSource('Energy drink (8oz)', 80),
  CaffeineSource('Dark chocolate (1oz)', 12),
  CaffeineSource('Pre-workout', 200),
];

/// Caffeine elimination half-life. Adult population mean ~5h, range 3–7h.
/// Smoking/CYP1A2 inducers shorten; pregnancy/oral contraceptives lengthen.
const defaultHalfLifeHours = 5.0;

/// Remaining mg after `elapsed` for one dose.
double remainingMg(
  int initialMg,
  Duration elapsed, {
  double halfLifeHours = defaultHalfLifeHours,
}) {
  if (elapsed.isNegative) return 0;
  final h = elapsed.inMinutes / 60.0;
  return initialMg * math.pow(0.5, h / halfLifeHours).toDouble();
}

/// Sum of remaining caffeine across all doses at a given time.
double remainingAtTime(
  Iterable<({DateTime consumedAt, int mg})> doses,
  DateTime at, {
  double halfLifeHours = defaultHalfLifeHours,
}) {
  double total = 0;
  for (final d in doses) {
    final elapsed = at.difference(d.consumedAt);
    total += remainingMg(d.mg, elapsed, halfLifeHours: halfLifeHours);
  }
  return total;
}

/// Sample the decay curve from `from` to `to` at `stepMinutes` resolution.
List<({DateTime at, double mg})> sampleCurve(
  Iterable<({DateTime consumedAt, int mg})> doses, {
  required DateTime from,
  required DateTime to,
  int stepMinutes = 15,
  double halfLifeHours = defaultHalfLifeHours,
}) {
  final out = <({DateTime at, double mg})>[];
  var t = from;
  while (!t.isAfter(to)) {
    out.add((
      at: t,
      mg: remainingAtTime(doses, t, halfLifeHours: halfLifeHours),
    ));
    t = t.add(Duration(minutes: stepMinutes));
  }
  return out;
}

/// Recommended caffeine cutoff time to land at `targetMgAtBedtime` mg by bedtime.
/// Returns the wall time after which any new dose pushes you above target.
/// Single-dose simplification — assumes one upcoming dose of `doseMg`.
DateTime cutoffForSingleDose({
  required int doseMg,
  required DateTime bedtime,
  required double targetMgAtBedtime,
  double halfLifeHours = defaultHalfLifeHours,
}) {
  if (doseMg <= targetMgAtBedtime) return bedtime;
  // doseMg * 0.5^(t/half) <= target  →  t >= half * log2(dose/target)
  final hoursNeeded =
      halfLifeHours * (math.log(doseMg / targetMgAtBedtime) / math.ln2);
  return bedtime.subtract(Duration(minutes: (hoursNeeded * 60).round()));
}
