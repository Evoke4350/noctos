import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:noctos/core/time.dart';

void main() {
  group('time helpers', () {
    test('minutesOfDay round-trips through timeOfDayFromMinutes', () {
      final t = const TimeOfDay(hour: 7, minute: 30);
      expect(minutesOfDay(t), 450);
      final back = timeOfDayFromMinutes(450);
      expect(back.hour, 7);
      expect(back.minute, 30);
    });

    test('formatTimeOfDay zero-pads', () {
      expect(formatTimeOfDay(const TimeOfDay(hour: 6, minute: 5)), '06:05');
      expect(formatTimeOfDay(const TimeOfDay(hour: 23, minute: 0)), '23:00');
    });

    test('formatDuration omits hours when zero', () {
      expect(formatDuration(const Duration(minutes: 45)), '45m');
      expect(formatDuration(const Duration(hours: 7, minutes: 30)), '7h 30m');
    });
  });
}
