import 'package:flutter/material.dart';

int minutesOfDay(TimeOfDay t) => t.hour * 60 + t.minute;

TimeOfDay timeOfDayFromMinutes(int m) {
  final mm = m % (24 * 60);
  return TimeOfDay(hour: mm ~/ 60, minute: mm % 60);
}

String formatTimeOfDay(TimeOfDay t) {
  final h = t.hour.toString().padLeft(2, '0');
  final m = t.minute.toString().padLeft(2, '0');
  return '$h:$m';
}

String formatDuration(Duration d) {
  final h = d.inHours;
  final m = d.inMinutes.remainder(60);
  return h > 0 ? '${h}h ${m}m' : '${m}m';
}
