import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../services/health/health_connect_service.dart';
import '../../../services/health/providers.dart';
import '../../settings/widgets/health_connect_rationale_sheet.dart';

class HealthConnectNudgeBanner extends HookConsumerWidget {
  const HealthConnectNudgeBanner({super.key, required this.currentWeek});

  final int currentWeek;

  static const _shownKey = 'health.nudgeShownAt';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dismissedLocal = useState<bool>(false);
    final shouldShowAsync = useMemoized(() async {
      if (currentWeek < 2) return false;
      final status = await ref.read(healthConnectServiceProvider).status();
      if (status == HealthConnectStatus.granted ||
          status == HealthConnectStatus.partial ||
          status == HealthConnectStatus.unsupportedPlatform) {
        return false;
      }
      final prefs = await SharedPreferences.getInstance();
      return prefs.getString(_shownKey) == null;
    }, [currentWeek]);
    final snap = useFuture(shouldShowAsync);

    if (dismissedLocal.value) return const SizedBox.shrink();
    if (!snap.hasData || snap.data == false) return const SizedBox.shrink();

    return Card(
      margin: const EdgeInsets.fromLTRB(16, 8, 16, 0),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Curious how your sleep tracker lines up with your diary?',
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () async {
                    await _markShown();
                    dismissedLocal.value = true;
                  },
                  child: const Text('Not now'),
                ),
                const SizedBox(width: 8),
                FilledButton(
                  onPressed: () async {
                    final ok =
                        await HealthConnectRationaleSheet.show(context);
                    if (ok) {
                      await ref
                          .read(healthConnectServiceProvider)
                          .requestPermissions();
                      ref.invalidate(healthConnectStatusProvider);
                    }
                    await _markShown();
                    dismissedLocal.value = true;
                  },
                  child: const Text('Connect Health Connect'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _markShown() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_shownKey, DateTime.now().toIso8601String());
  }
}
