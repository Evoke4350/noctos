import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../core/time.dart';
import '../../data/db/database.dart';
import '../../data/repositories/caffeine_repository.dart';
import '../../data/repositories/schedule_repository.dart';
import '../../domain/caffeine/half_life.dart';

class CaffeineLogScreen extends HookConsumerWidget {
  const CaffeineLogScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final logsAsync = ref.watch(caffeineLast24hProvider);
    final scheduleAsync = ref.watch(scheduleProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Caffeine')),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showAddSheet(context, ref),
        icon: const Icon(Icons.add),
        label: const Text('Log'),
      ),
      body: SafeArea(
        child: logsAsync.when(
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (e, _) => Center(child: Text('Error: $e')),
          data: (logs) {
            return scheduleAsync.when(
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (e, _) => Center(child: Text('Error: $e')),
              data: (schedule) {
                final now = DateTime.now();
                final bedtime = _nextBedtime(
                  schedule?.currentBedtimeMinutesOfDay ?? 23 * 60,
                );
                final doses = logs
                    .map((l) => (consumedAt: l.consumedAt, mg: l.mg))
                    .toList();
                final atBedtime = remainingAtTime(doses, bedtime);

                return ListView(
                  padding: const EdgeInsets.fromLTRB(20, 20, 20, 100),
                  children: [
                    Card(
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Predicted at bedtime ${formatTimeOfDay(timeOfDayFromMinutes(schedule?.currentBedtimeMinutesOfDay ?? 23 * 60))}',
                              style: Theme.of(context).textTheme.bodyMedium,
                            ),
                            const SizedBox(height: 4),
                            Text(
                              '${atBedtime.toStringAsFixed(0)} mg',
                              style: Theme.of(context).textTheme.headlineMedium,
                            ),
                            const SizedBox(height: 12),
                            SizedBox(
                              height: 140,
                              child: _DecayChart(
                                doses: doses,
                                from: now,
                                to: bedtime,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Half-life ≈ 5h. Aim for under ~50mg at bedtime.',
                              style: Theme.of(context).textTheme.bodyMedium
                                  ?.copyWith(
                                    color: Theme.of(
                                      context,
                                    ).colorScheme.onSurfaceVariant,
                                  ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Last 24h',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 8),
                    if (logs.isEmpty)
                      Padding(
                        padding: const EdgeInsets.all(20),
                        child: Text(
                          'No caffeine logged.',
                          style: Theme.of(context).textTheme.bodyMedium
                              ?.copyWith(
                                color: Theme.of(
                                  context,
                                ).colorScheme.onSurfaceVariant,
                              ),
                        ),
                      )
                    else
                      ...logs.map((l) => _Tile(log: l, ref: ref)),
                  ],
                );
              },
            );
          },
        ),
      ),
    );
  }

  DateTime _nextBedtime(int bedtimeMinutesOfDay) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final bedToday = today.add(Duration(minutes: bedtimeMinutesOfDay));
    return bedToday.isBefore(now)
        ? bedToday.add(const Duration(days: 1))
        : bedToday;
  }

  void _showAddSheet(BuildContext context, WidgetRef ref) {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      builder: (ctx) => Padding(
        padding: EdgeInsets.only(bottom: MediaQuery.of(ctx).viewInsets.bottom),
        child: _AddSheet(),
      ),
    );
  }
}

class _Tile extends StatelessWidget {
  final CaffeineLog log;
  final WidgetRef ref;
  const _Tile({required this.log, required this.ref});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: ListTile(
        title: Text(log.source ?? 'Caffeine'),
        subtitle: Text(formatTimeOfDay(TimeOfDay.fromDateTime(log.consumedAt))),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('${log.mg}mg', style: Theme.of(context).textTheme.titleMedium),
            IconButton(
              icon: const Icon(Icons.delete_outline, size: 20),
              onPressed: () =>
                  ref.read(caffeineRepositoryProvider).delete(log.id),
            ),
          ],
        ),
      ),
    );
  }
}

class _AddSheet extends HookConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final mg = useState(95);
    final source = useState<String?>('Drip coffee (8oz)');
    final time = useState<TimeOfDay>(TimeOfDay.now());

    Future<void> save() async {
      final now = DateTime.now();
      final consumedAt = DateTime(
        now.year,
        now.month,
        now.day,
        time.value.hour,
        time.value.minute,
      );
      await ref
          .read(caffeineRepositoryProvider)
          .insert(consumedAt, mg.value, source.value);
      if (!context.mounted) return;
      Navigator.of(context).pop();
    }

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Log caffeine', style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 16),
            Wrap(
              spacing: 8,
              runSpacing: 4,
              children: commonCaffeineSources.map((s) {
                final selected = source.value == s.label;
                return ChoiceChip(
                  label: Text('${s.label} · ${s.mg}mg'),
                  selected: selected,
                  onSelected: (_) {
                    source.value = s.label;
                    mg.value = s.mg;
                  },
                );
              }).toList(),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: TextEditingController(
                      text: mg.value.toString(),
                    ),
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(labelText: 'mg'),
                    onSubmitted: (v) {
                      final parsed = int.tryParse(v);
                      if (parsed != null) mg.value = parsed;
                    },
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: OutlinedButton.icon(
                    icon: const Icon(Icons.access_time),
                    label: Text(formatTimeOfDay(time.value)),
                    onPressed: () async {
                      final picked = await showTimePicker(
                        context: context,
                        initialTime: time.value,
                      );
                      if (picked != null) time.value = picked;
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            FilledButton(onPressed: save, child: const Text('Save')),
          ],
        ),
      ),
    );
  }
}

class _DecayChart extends StatelessWidget {
  final List<({DateTime consumedAt, int mg})> doses;
  final DateTime from;
  final DateTime to;

  const _DecayChart({
    required this.doses,
    required this.from,
    required this.to,
  });

  @override
  Widget build(BuildContext context) {
    if (!from.isBefore(to)) return const SizedBox.shrink();
    final samples = sampleCurve(doses, from: from, to: to, stepMinutes: 15);
    if (samples.length < 2) {
      return Center(
        child: Text(
          'Nothing to show yet.',
          style: Theme.of(context).textTheme.bodyMedium,
        ),
      );
    }
    final spots = <FlSpot>[];
    for (var i = 0; i < samples.length; i++) {
      spots.add(FlSpot(i.toDouble(), samples[i].mg));
    }
    final maxY = (spots.map((s) => s.y).reduce((a, b) => a > b ? a : b)) * 1.2;
    return LineChart(
      LineChartData(
        minY: 0,
        maxY: maxY < 50 ? 50 : maxY,
        gridData: const FlGridData(show: false),
        titlesData: FlTitlesData(
          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 36,
              getTitlesWidget: (v, _) => Text(
                '${v.toInt()}',
                style: Theme.of(
                  context,
                ).textTheme.bodyMedium?.copyWith(fontSize: 10),
              ),
            ),
          ),
          rightTitles: const AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
          topTitles: const AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
          bottomTitles: const AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
        ),
        borderData: FlBorderData(show: false),
        extraLinesData: ExtraLinesData(
          horizontalLines: [
            HorizontalLine(
              y: 50,
              dashArray: const [4, 4],
              color: Theme.of(
                context,
              ).colorScheme.primary.withValues(alpha: 0.4),
              strokeWidth: 1,
            ),
          ],
        ),
        lineBarsData: [
          LineChartBarData(
            spots: spots,
            isCurved: true,
            barWidth: 2,
            color: Theme.of(context).colorScheme.primary,
            dotData: const FlDotData(show: false),
            belowBarData: BarAreaData(
              show: true,
              color: Theme.of(
                context,
              ).colorScheme.primary.withValues(alpha: 0.1),
            ),
          ),
        ],
      ),
    );
  }
}
