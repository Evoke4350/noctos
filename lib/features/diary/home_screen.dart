import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../core/time.dart';
import '../../data/repositories/cbti_week_repository.dart';
import '../../data/repositories/schedule_repository.dart';
import '../../data/repositories/diary_repository.dart';
import '../../domain/cbti/protocol.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final scheduleAsync = ref.watch(scheduleProvider);
    final diaryAsync = ref.watch(diaryStreamProvider);
    final weekAsync = ref.watch(currentCbtiWeekProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('noctos'),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings_outlined),
            onPressed: () => context.go('/settings'),
          ),
        ],
      ),
      body: SafeArea(
        child: scheduleAsync.when(
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (e, _) => Center(child: Text('Error: $e')),
          data: (schedule) {
            if (schedule == null) {
              return const Center(child: Text('No schedule yet'));
            }
            final wake = timeOfDayFromMinutes(schedule.fixedWakeMinutesOfDay);
            final bed = timeOfDayFromMinutes(schedule.currentBedtimeMinutesOfDay);

            return ListView(
              padding: const EdgeInsets.all(20),
              children: [
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Tonight',
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                        const SizedBox(height: 16),
                        _Row(label: 'Bedtime window opens', value: formatTimeOfDay(bed)),
                        const SizedBox(height: 8),
                        _Row(label: 'Wake time', value: formatTimeOfDay(wake)),
                        const SizedBox(height: 8),
                        _Row(
                          label: 'Time in bed',
                          value: formatDuration(Duration(minutes: schedule.currentTibMinutes)),
                        ),
                        const SizedBox(height: 16),
                        const Divider(),
                        const SizedBox(height: 12),
                        Text(
                          'Bed = sleep only. If you are awake more than 20 minutes, get up and do something quiet in dim light until sleepy.',
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                weekAsync.maybeWhen(
                  data: (week) {
                    if (week == null) return const SizedBox.shrink();
                    final spec = specFor(phaseFromId(week.phaseId));
                    return Card(
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              spec.title,
                              style: Theme.of(context).textTheme.titleMedium,
                            ),
                            const SizedBox(height: 4),
                            Text(
                              spec.subtitle,
                              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                                  ),
                            ),
                            const SizedBox(height: 12),
                            Text(week.rationale,
                                style: Theme.of(context).textTheme.bodyMedium),
                          ],
                        ),
                      ),
                    );
                  },
                  orElse: () => const SizedBox.shrink(),
                ),
                const SizedBox(height: 16),
                FilledButton.icon(
                  onPressed: () => context.go('/diary/new'),
                  icon: const Icon(Icons.edit_note),
                  label: const Text('Log last night'),
                ),
                const SizedBox(height: 8),
                OutlinedButton.icon(
                  onPressed: () => context.go('/diary/history'),
                  icon: const Icon(Icons.history),
                  label: Text(
                    diaryAsync.maybeWhen(
                      data: (rows) => 'History (${rows.length})',
                      orElse: () => 'History',
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                OutlinedButton.icon(
                  onPressed: () => context.go('/program'),
                  icon: const Icon(Icons.timeline),
                  label: const Text('Program'),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

class _Row extends StatelessWidget {
  final String label;
  final String value;
  const _Row({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: Theme.of(context).textTheme.bodyLarge),
        Text(value, style: Theme.of(context).textTheme.titleMedium),
      ],
    );
  }
}
