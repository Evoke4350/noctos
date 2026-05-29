/// Ranks a sleep-data source: higher = more authoritative. Used by the read
/// layer to pick which source's record represents a night when several sources
/// wrote one. This is product policy, not correctness — tune freely.
///
/// Matching is on whole tokens (not naive substring) so "Husband's Phone" does
/// not match "band" and "Galaxy Buds" (earbuds, no sleep sensor) does not
/// inherit the wrist-wearable tier.
int sourceTrust(String? app, String? device) {
  final tokens = '${app ?? ''} ${device ?? ''}'
      .toLowerCase()
      .split(RegExp(r'[^a-z0-9]+'))
      .where((t) => t.isNotEmpty)
      .toSet();
  bool has(String t) => tokens.contains(t);

  if (has('oura') ||
      has('whoop') ||
      has('withings') ||
      (has('eight') && has('sleep'))) {
    return 40; // dedicated sleep tracker
  }
  if (has('buds')) {
    return 10; // earbuds: not a sleep sensor, below wrist wearables
  }
  if (has('garmin') ||
      has('fitbit') ||
      has('galaxy') ||
      has('watch') ||
      has('band')) {
    return 30; // wrist wearable
  }
  if (has('pixel') || has('phone') || (has('sleep') && has('android'))) {
    return 20; // phone-class sensor
  }
  if (tokens.isEmpty) {
    return 0; // unknown / manual
  }
  return 10;
}
