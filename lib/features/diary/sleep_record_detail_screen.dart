import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';

import '../../data/db/database.dart';
import '../../data/repositories/sleep_record_repository.dart';
import '../../services/health/models.dart';

class SleepRecordDetailScreen extends ConsumerWidget {
  const SleepRecordDetailScreen({super.key, required this.diaryDate});

  final DateTime diaryDate;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final async = ref.watch(sleepRecordForNightProvider(diaryDate));
    final dateLabel = DateFormat('EEE d MMM').format(diaryDate);
    return Scaffold(
      appBar: AppBar(title: Text('$dateLabel · watch data')),
      body: async.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Error: $e')),
        data: (record) {
          if (record == null) {
            return const Center(child: Text('No watch data for this night.'));
          }
          return _Body(record: record);
        },
      ),
    );
  }
}

class _Body extends StatelessWidget {
  const _Body({required this.record});
  final SleepRecord record;

  @override
  Widget build(BuildContext context) {
    final fmt = DateFormat('h:mma');
    final hours = record.totalMinutes ~/ 60;
    final mins = record.totalMinutes % 60;
    final stages = HealthSleepRecord.stagesFromJson(record.stagesJson);
    final source = [
      record.sourceDevice,
      record.sourceApp,
    ].where((s) => s != null && s.isNotEmpty).join(' via ');

    final children = <Widget>[
      _row(
        context,
        'Session',
        '${fmt.format(record.sessionStart).toLowerCase()} → '
            '${fmt.format(record.sessionEnd).toLowerCase()} '
            '(${hours}h ${mins}m)',
      ),
      if (source.isNotEmpty) _row(context, 'Source', source),
      if (stages.isNotEmpty) ...[
        const SizedBox(height: 16),
        Text('Stages', style: Theme.of(context).textTheme.titleSmall),
        const SizedBox(height: 8),
        _StageBand(stages: stages),
        const SizedBox(height: 8),
        _StageLegend(stages: stages),
      ],
      if (record.hrAvgBpm != null)
        _row(
          context,
          'Heart rate',
          'avg ${record.hrAvgBpm!.round()} bpm'
              '${record.restingHrBpm != null ? " · resting ${record.restingHrBpm!.round()}" : ""}',
        ),
      if (record.hrvAvgMs != null)
        _row(context, 'HRV (RMSSD)', '${record.hrvAvgMs!.round()} ms'),
      const SizedBox(height: 24),
      const Divider(),
      const Padding(
        padding: EdgeInsets.symmetric(vertical: 8),
        child: Text(
          'Watch data informational. Diary drives program.',
          style: TextStyle(fontStyle: FontStyle.italic),
        ),
      ),
    ];

    return ListView(padding: const EdgeInsets.all(16), children: children);
  }

  Widget _row(BuildContext c, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 110,
            child: Text(
              label,
              style: Theme.of(
                c,
              ).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(child: Text(value)),
        ],
      ),
    );
  }
}

class _StageBand extends StatelessWidget {
  const _StageBand({required this.stages});
  final List<SleepStageSpan> stages;

  static Color colorFor(SleepStage s) {
    switch (s) {
      case SleepStage.awake:
        return Colors.orange;
      case SleepStage.light:
        return Colors.blueGrey;
      case SleepStage.deep:
        return Colors.indigo;
      case SleepStage.rem:
        return Colors.deepPurple;
      case SleepStage.outOfBed:
        return Colors.brown;
      case SleepStage.unknown:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    final total = stages.fold<int>(0, (acc, s) => acc + s.duration.inMinutes);
    if (total == 0) return const SizedBox.shrink();
    return SizedBox(
      height: 16,
      child: Row(
        children: stages
            .map(
              (s) => Expanded(
                flex: s.duration.inMinutes,
                child: Container(color: colorFor(s.stage)),
              ),
            )
            .toList(),
      ),
    );
  }
}

class _StageLegend extends StatelessWidget {
  const _StageLegend({required this.stages});
  final List<SleepStageSpan> stages;

  @override
  Widget build(BuildContext context) {
    final byStage = <SleepStage, int>{};
    for (final s in stages) {
      byStage[s.stage] = (byStage[s.stage] ?? 0) + s.duration.inMinutes;
    }
    return Wrap(
      spacing: 12,
      runSpacing: 4,
      children: byStage.entries.map((e) {
        final h = e.value ~/ 60;
        final m = e.value % 60;
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(width: 10, height: 10, color: _StageBand.colorFor(e.key)),
            const SizedBox(width: 4),
            Text('${e.key.name} ${h > 0 ? "${h}h " : ""}${m}m'),
          ],
        );
      }).toList(),
    );
  }
}
