import 'package:flutter_test/flutter_test.dart';

import 'package:noctos/domain/caffeine/half_life.dart';

void main() {
  group('remainingMg', () {
    test('returns full dose at t=0', () {
      expect(remainingMg(200, Duration.zero), closeTo(200, 0.0001));
    });

    test('halves after one half-life (5h default)', () {
      expect(
        remainingMg(200, const Duration(hours: 5)),
        closeTo(100, 0.0001),
      );
    });

    test('quarters after two half-lives', () {
      expect(
        remainingMg(200, const Duration(hours: 10)),
        closeTo(50, 0.0001),
      );
    });

    test('returns 0 for negative elapsed (future)', () {
      expect(
        remainingMg(200, const Duration(hours: -1)),
        0,
      );
    });

    test('respects custom half-life', () {
      expect(
        remainingMg(100, const Duration(hours: 3), halfLifeHours: 3),
        closeTo(50, 0.0001),
      );
    });
  });

  group('remainingAtTime', () {
    test('sums multiple doses', () {
      final now = DateTime(2026, 5, 12, 22, 0); // 10pm
      final doses = [
        (consumedAt: DateTime(2026, 5, 12, 17, 0), mg: 200), // 5h ago → 100
        (consumedAt: DateTime(2026, 5, 12, 7, 0), mg: 200),  // 15h ago = 3 half-lives → 25
      ];
      expect(
        remainingAtTime(doses, now),
        closeTo(125, 0.0001),
      );
    });

    test('zero for empty doses', () {
      expect(remainingAtTime(const [], DateTime.now()), 0);
    });

    test('future doses contribute zero', () {
      final now = DateTime(2026, 5, 12, 10, 0);
      final doses = [
        (consumedAt: DateTime(2026, 5, 12, 14, 0), mg: 200), // future
      ];
      expect(remainingAtTime(doses, now), 0);
    });
  });

  group('cutoffForSingleDose', () {
    test('returns bedtime when dose <= target', () {
      final bedtime = DateTime(2026, 5, 12, 23, 0);
      expect(
        cutoffForSingleDose(
          doseMg: 30,
          bedtime: bedtime,
          targetMgAtBedtime: 50,
        ),
        bedtime,
      );
    });

    test('200mg, 50mg target, 5h half: cutoff is 2 half-lives before bed = 10h', () {
      final bedtime = DateTime(2026, 5, 12, 23, 0);
      final cutoff = cutoffForSingleDose(
        doseMg: 200,
        bedtime: bedtime,
        targetMgAtBedtime: 50,
      );
      // 200 → 50 over 2 half-lives = 10h. So cutoff = 13:00.
      expect(cutoff.hour, 13);
      expect(cutoff.minute, 0);
    });
  });
}
