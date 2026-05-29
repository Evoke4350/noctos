import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../data/db/database.dart';
import '../../data/repositories/diary_repository.dart';
import 'widgets/sleep_record_strip.dart';

class DiaryHistoryScreen extends ConsumerWidget {
  const DiaryHistoryScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final async = ref.watch(diaryStreamProvider);
    return Scaffold(
      appBar: AppBar(title: const Text('History')),
      body: SafeArea(
        child: async.when(
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (e, _) => Center(child: Text('Error: $e')),
          data: (rows) {
            if (rows.isEmpty) {
              return const Center(child: Text('No entries yet'));
            }
            final ordered = rows.reversed.toList();
            return ListView(
              padding: const EdgeInsets.all(20),
              children: [
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Sleep efficiency',
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        const SizedBox(height: 12),
                        SizedBox(
                          height: 180,
                          child: _EfficiencyChart(entries: ordered),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                ...rows.map((e) => _Tile(entry: e)),
              ],
            );
          },
        ),
      ),
    );
  }
}

class _Tile extends StatelessWidget {
  final SleepDiaryEntry entry;
  const _Tile({required this.entry});

  @override
  Widget build(BuildContext context) {
    final tib = entry.outOfBedTime.difference(entry.bedtime).inMinutes;
    final tst = (tib - entry.sleepLatencyMin - entry.wasoMin).clamp(0, tib);
    final eff = tib > 0 ? tst / tib : 0;
    final pct = (eff * 100).toStringAsFixed(0);
    final d = entry.diaryDate;
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          ListTile(
            title: Text('${d.month}/${d.day}/${d.year}'),
            subtitle: Text(
              'TIB ${_fmt(tib)} · TST ${_fmt(tst)} · awakenings ${entry.awakeningsCount}'
              '${entry.adherentToPrescription ? '' : ' · non-adherent'}',
            ),
            trailing: Text(
              '$pct%',
              style: Theme.of(context).textTheme.titleMedium,
            ),
          ),
          SleepRecordStrip(diaryDate: entry.diaryDate),
        ],
      ),
    );
  }

  String _fmt(int min) {
    final h = min ~/ 60;
    final m = min % 60;
    return '${h}h${m.toString().padLeft(2, '0')}';
  }
}

class _EfficiencyChart extends StatelessWidget {
  final List<SleepDiaryEntry> entries;
  const _EfficiencyChart({required this.entries});

  @override
  Widget build(BuildContext context) {
    if (entries.isEmpty) return const SizedBox.shrink();
    final spots = <FlSpot>[];
    for (var i = 0; i < entries.length; i++) {
      final e = entries[i];
      final tib = e.outOfBedTime.difference(e.bedtime).inMinutes;
      if (tib <= 0) continue;
      final tst = tib - e.sleepLatencyMin - e.wasoMin;
      final eff = (tst / tib * 100).clamp(0.0, 100.0);
      spots.add(FlSpot(i.toDouble(), eff));
    }
    return LineChart(
      LineChartData(
        minY: 0,
        maxY: 100,
        gridData: FlGridData(
          show: true,
          drawVerticalLine: false,
          horizontalInterval: 25,
          getDrawingHorizontalLine: (v) => FlLine(
            color: Theme.of(
              context,
            ).colorScheme.outline.withValues(alpha: 0.15),
            strokeWidth: 1,
          ),
        ),
        titlesData: FlTitlesData(
          rightTitles: const AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
          topTitles: const AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              interval: 25,
              reservedSize: 32,
              getTitlesWidget: (v, _) => Text(
                '${v.toInt()}%',
                style: Theme.of(
                  context,
                ).textTheme.bodyMedium?.copyWith(fontSize: 10),
              ),
            ),
          ),
          bottomTitles: const AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
        ),
        borderData: FlBorderData(show: false),
        extraLinesData: ExtraLinesData(
          horizontalLines: [
            HorizontalLine(
              y: 85,
              dashArray: [4, 4],
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
            dotData: const FlDotData(show: true),
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
