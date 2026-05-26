import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../services/health/health_connect_service.dart';
import '../../../services/health/providers.dart';
import '../../../services/health/sleep_record_sync.dart';
import 'health_connect_rationale_sheet.dart';

class HealthConnectSection extends ConsumerWidget {
  const HealthConnectSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final statusAsync = ref.watch(healthConnectStatusProvider);
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: statusAsync.when(
          loading: () => const LinearProgressIndicator(),
          error: (e, _) => Text('Error: $e'),
          data: (status) => _body(context, ref, status),
        ),
      ),
    );
  }

  Widget _body(BuildContext context, WidgetRef ref, HealthConnectStatus s) {
    switch (s) {
      case HealthConnectStatus.unsupportedPlatform:
        return const Text('Available on Android only.');
      case HealthConnectStatus.notInstalled:
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Health Connect not installed'),
            const SizedBox(height: 8),
            FilledButton(
              onPressed: () => ref
                  .read(healthConnectServiceProvider)
                  .installHealthConnectApp(),
              child: const Text('Install from Play Store'),
            ),
          ],
        );
      case HealthConnectStatus.needsPermissions:
      case HealthConnectStatus.denied:
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Not connected'),
            const SizedBox(height: 8),
            FilledButton(
              onPressed: () => _connect(context, ref),
              child: const Text('Connect'),
            ),
          ],
        );
      case HealthConnectStatus.granted:
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: const [
                Icon(Icons.check_circle, size: 18),
                SizedBox(width: 6),
                Text('Connected'),
              ],
            ),
            const SizedBox(height: 8),
            const Text('Reading: sleep, heart rate, HRV, resting HR'),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              children: [
                OutlinedButton(
                  onPressed: () =>
                      ref.read(sleepRecordSyncProvider).syncRecent(force: true),
                  child: const Text('Sync now'),
                ),
                TextButton(
                  onPressed: () async {
                    await ref
                        .read(healthConnectServiceProvider)
                        .revokePermissions();
                    ref.invalidate(healthConnectStatusProvider);
                  },
                  child: const Text('Disconnect'),
                ),
              ],
            ),
          ],
        );
    }
  }

  Future<void> _connect(BuildContext context, WidgetRef ref) async {
    final proceed = await HealthConnectRationaleSheet.show(context);
    if (!proceed) return;
    await ref.read(healthConnectServiceProvider).requestPermissions();
    ref.invalidate(healthConnectStatusProvider);
  }
}
