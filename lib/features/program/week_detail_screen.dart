import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../core/time.dart';
import '../../data/repositories/cbti_week_repository.dart';
import '../../domain/cbti/protocol.dart';

class WeekDetailScreen extends ConsumerWidget {
  final int weekIndex;
  const WeekDetailScreen({super.key, required this.weekIndex});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final spec = cbtiProtocol.firstWhere(
      (s) => s.approxWeekIndex == weekIndex && s.phase != CBTIPhase.stimulusControl,
      orElse: () => cbtiProtocol.first,
    );
    final currentAsync = ref.watch(currentCbtiWeekProvider);

    return Scaffold(
      appBar: AppBar(title: Text(spec.title)),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            Text(spec.subtitle, style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 16),
            Text(spec.rationale, style: Theme.of(context).textTheme.bodyLarge),
            const SizedBox(height: 24),
            currentAsync.when(
              loading: () => const SizedBox.shrink(),
              error: (_, __) => const SizedBox.shrink(),
              data: (current) {
                if (current == null) return const SizedBox.shrink();
                if (phaseFromId(current.phaseId) != spec.phase) return const SizedBox.shrink();
                final bed = timeOfDayFromMinutes(current.prescribedBedtimeMinutesOfDay);
                final wake = timeOfDayFromMinutes(current.prescribedWakeMinutesOfDay);
                return Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Current prescription',
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        const SizedBox(height: 12),
                        _kv('Bedtime window', formatTimeOfDay(bed)),
                        _kv('Wake', formatTimeOfDay(wake)),
                        _kv('Time in bed',
                            formatDuration(Duration(minutes: current.tibMinutes))),
                        _kv('Last action', current.action),
                        const SizedBox(height: 12),
                        const Divider(),
                        const SizedBox(height: 12),
                        Text(current.rationale,
                            style: Theme.of(context).textTheme.bodyMedium),
                      ],
                    ),
                  ),
                );
              },
            ),
            const SizedBox(height: 24),
            Text('Daily',
                style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 8),
            ...spec.daily.map(
              (item) => Padding(
                padding: const EdgeInsets.symmetric(vertical: 4),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Padding(
                      padding: EdgeInsets.only(top: 4),
                      child: Icon(Icons.circle, size: 6),
                    ),
                    const SizedBox(width: 12),
                    Expanded(child: Text(item)),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _kv(String k, String v) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(k),
          Text(v),
        ],
      ),
    );
  }
}
