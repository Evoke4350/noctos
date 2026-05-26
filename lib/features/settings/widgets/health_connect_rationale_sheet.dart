import 'package:flutter/material.dart';

class HealthConnectRationaleSheet extends StatelessWidget {
  const HealthConnectRationaleSheet({super.key});

  /// Returns true if user tapped Continue, false if Cancel/dismiss.
  static Future<bool> show(BuildContext context) async {
    final result = await showModalBottomSheet<bool>(
      context: context,
      isScrollControlled: true,
      builder: (_) => const HealthConnectRationaleSheet(),
    );
    return result ?? false;
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Connect Health Connect',
                style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 12),
            const Text('noctos will read:'),
            const SizedBox(height: 8),
            const _Bullet('Sleep sessions (start, end, stages)'),
            const _Bullet('Heart rate during sleep'),
            const _Bullet('HRV (RMSSD)'),
            const _Bullet('Resting heart rate'),
            const SizedBox(height: 16),
            const Text(
              'Data stays on this device. noctos has no servers, '
              'no telemetry, no analytics.',
            ),
            const SizedBox(height: 8),
            const Text(
              'Watch data is informational only. Your diary entries '
              'drive the CBT-I program.',
              style: TextStyle(fontStyle: FontStyle.italic),
            ),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(false),
                  child: const Text('Cancel'),
                ),
                const SizedBox(width: 8),
                FilledButton(
                  onPressed: () => Navigator.of(context).pop(true),
                  child: const Text('Continue'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _Bullet extends StatelessWidget {
  const _Bullet(this.text);
  final String text;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('• '),
          Expanded(child: Text(text)),
        ],
      ),
    );
  }
}
