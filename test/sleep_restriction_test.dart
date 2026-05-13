import 'package:flutter_test/flutter_test.dart';

import 'package:noctos/domain/cbti/sleep_restriction.dart';

NightSample night({required int tib, required double se, bool adherent = true}) {
  final tst = (tib * se).round();
  return NightSample(timeInBedMin: tib, totalSleepMin: tst, adherent: adherent);
}

void main() {
  const wakeMin = 7 * 60; // 07:00

  group('seed (firstPrescription)', () {
    test('seeds from mean TST rounded to 15, clamped to floor', () {
      // 5 adherent nights, each 3h sleep — well under 5h floor
      final out = computeNextSleepWindow(SleepRestrictionInput(
        recentEntries: List.generate(5, (_) => night(tib: 420, se: 180 / 420)),
        fixedWakeMinutesOfDay: wakeMin,
      ));
      expect(out.action, 'seed');
      expect(out.tibMinutes, 300); // 5h floor
      expect(out.bedtimeMinutesOfDay, (wakeMin - 300) % (24 * 60));
    });

    test('seeds capped at natural cap', () {
      final out = computeNextSleepWindow(SleepRestrictionInput(
        recentEntries: List.generate(7, (_) => night(tib: 600, se: 580 / 600)),
        fixedWakeMinutesOfDay: wakeMin,
        naturalCapMinutes: 480,
      ));
      expect(out.action, 'seed');
      expect(out.tibMinutes, 480);
    });

    test('seeds round to nearest 15', () {
      // 7 nights × 6h50m sleep = 410m. Round-to-15 = 405.
      final out = computeNextSleepWindow(SleepRestrictionInput(
        recentEntries: List.generate(7, (_) => night(tib: 480, se: 410 / 480)),
        fixedWakeMinutesOfDay: wakeMin,
      ));
      expect(out.action, 'seed');
      expect(out.tibMinutes, 405);
    });

    test('fallback to 7h when no data', () {
      final out = computeNextSleepWindow(SleepRestrictionInput(
        recentEntries: const [],
        fixedWakeMinutesOfDay: wakeMin,
      ));
      expect(out.action, 'seed');
      expect(out.tibMinutes, 420);
    });
  });

  group('titration with currentTib set', () {
    test('expand when SE ≥ 85%', () {
      final out = computeNextSleepWindow(SleepRestrictionInput(
        recentEntries: List.generate(5, (_) => night(tib: 360, se: 0.90)),
        fixedWakeMinutesOfDay: wakeMin,
        currentTibMinutes: 360,
      ));
      expect(out.action, 'expand');
      expect(out.tibMinutes, 375);
    });

    test('expand boundary: SE exactly 0.85 expands', () {
      final out = computeNextSleepWindow(SleepRestrictionInput(
        recentEntries: List.generate(5, (_) => night(tib: 400, se: 0.85)),
        fixedWakeMinutesOfDay: wakeMin,
        currentTibMinutes: 360,
      ));
      expect(out.action, 'expand');
    });

    test('hold when 0.80 ≤ SE < 0.85', () {
      final out = computeNextSleepWindow(SleepRestrictionInput(
        recentEntries: List.generate(5, (_) => night(tib: 360, se: 0.82)),
        fixedWakeMinutesOfDay: wakeMin,
        currentTibMinutes: 360,
      ));
      expect(out.action, 'hold');
      expect(out.tibMinutes, 360);
    });

    test('contract when SE < 0.80', () {
      final out = computeNextSleepWindow(SleepRestrictionInput(
        recentEntries: List.generate(5, (_) => night(tib: 360, se: 0.70)),
        fixedWakeMinutesOfDay: wakeMin,
        currentTibMinutes: 360,
      ));
      expect(out.action, 'contract');
      expect(out.tibMinutes, 345);
    });

    test('floor: contract would go below 5h → floor action', () {
      final out = computeNextSleepWindow(SleepRestrictionInput(
        recentEntries: List.generate(5, (_) => night(tib: 305, se: 0.60)),
        fixedWakeMinutesOfDay: wakeMin,
        currentTibMinutes: 305,
      ));
      expect(out.action, 'floor');
      expect(out.tibMinutes, 300);
    });

    test('floor: already at 5h and contract requested → floor stays', () {
      final out = computeNextSleepWindow(SleepRestrictionInput(
        recentEntries: List.generate(5, (_) => night(tib: 300, se: 0.50)),
        fixedWakeMinutesOfDay: wakeMin,
        currentTibMinutes: 300,
      ));
      expect(out.action, 'floor');
      expect(out.tibMinutes, 300);
    });

    test('cap: expand requested but at cap → hold', () {
      final out = computeNextSleepWindow(SleepRestrictionInput(
        recentEntries: List.generate(5, (_) => night(tib: 480, se: 0.95)),
        fixedWakeMinutesOfDay: wakeMin,
        currentTibMinutes: 480,
        naturalCapMinutes: 480,
      ));
      expect(out.action, 'hold');
      expect(out.tibMinutes, 480);
    });
  });

  group('adherence filtering', () {
    test('non-adherent nights excluded from titration', () {
      // 5 non-adherent terrible nights + 5 adherent great nights →
      // algorithm should expand based on adherent only.
      final entries = [
        ...List.generate(5, (_) => night(tib: 480, se: 0.30, adherent: false)),
        ...List.generate(5, (_) => night(tib: 360, se: 0.90, adherent: true)),
      ];
      final out = computeNextSleepWindow(SleepRestrictionInput(
        recentEntries: entries,
        fixedWakeMinutesOfDay: wakeMin,
        currentTibMinutes: 360,
      ));
      expect(out.action, 'expand');
    });

    test('not enough adherent nights → hold', () {
      final entries = [
        ...List.generate(6, (_) => night(tib: 360, se: 0.90, adherent: false)),
        ...List.generate(3, (_) => night(tib: 360, se: 0.90, adherent: true)),
      ];
      final out = computeNextSleepWindow(SleepRestrictionInput(
        recentEntries: entries,
        fixedWakeMinutesOfDay: wakeMin,
        currentTibMinutes: 360,
      ));
      expect(out.action, 'hold');
      expect(out.rationale, contains('adherent nights to titrate'));
    });
  });

  group('bedtime derivation', () {
    test('bedtime = wake − tib, wrapping past midnight', () {
      final out = computeNextSleepWindow(SleepRestrictionInput(
        recentEntries: const [],
        fixedWakeMinutesOfDay: 6 * 60, // 06:00
        currentTibMinutes: null,
      ));
      // seed defaults to 420m → bedtime should be 06:00 − 7h = 23:00 yesterday
      expect(out.tibMinutes, 420);
      expect(out.bedtimeMinutesOfDay, 23 * 60);
    });

    test('bedtime wraps when wake is past midnight', () {
      final out = computeNextSleepWindow(SleepRestrictionInput(
        recentEntries: List.generate(5, (_) => night(tib: 360, se: 0.82)),
        fixedWakeMinutesOfDay: 2 * 60, // 02:00 (eg evening type)
        currentTibMinutes: 360,
      ));
      // 02:00 − 6h = 20:00
      expect(out.bedtimeMinutesOfDay, 20 * 60);
    });
  });
}
