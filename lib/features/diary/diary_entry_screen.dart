import 'package:drift/drift.dart' as drift;
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../core/time.dart';
import '../../data/db/database.dart';
import '../../data/repositories/diary_repository.dart';
import '../../domain/cbti/engine.dart';

class DiaryEntryScreen extends HookConsumerWidget {
  const DiaryEntryScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final now = DateTime.now();
    final lastNight = DateTime(
      now.year,
      now.month,
      now.day,
    ).subtract(const Duration(days: 1));

    final diaryDate = useState(lastNight);
    final bedtime = useState(_at(lastNight, 23, 0));
    final lightsOut = useState(_at(lastNight, 23, 30));
    final wakeTime = useState(_at(now, 7, 0));
    final outOfBedTime = useState(_at(now, 7, 10));
    final latency = useState(20);
    final awakenings = useState(1);
    final waso = useState(15);
    final quality = useState(3);
    final mood = useState(3);
    final adherent = useState(true);
    final notes = useTextEditingController();
    final saving = useState(false);

    Future<void> pickDateTime(ValueNotifier<DateTime> target) async {
      final date = await showDatePicker(
        context: context,
        initialDate: target.value,
        firstDate: now.subtract(const Duration(days: 90)),
        lastDate: now.add(const Duration(days: 1)),
      );
      if (date == null || !context.mounted) return;
      final time = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.fromDateTime(target.value),
      );
      if (time == null) return;
      target.value = DateTime(
        date.year,
        date.month,
        date.day,
        time.hour,
        time.minute,
      );
    }

    int totalSleep() {
      final tib = outOfBedTime.value.difference(bedtime.value).inMinutes;
      return tib - latency.value - waso.value;
    }

    int timeInBed() => outOfBedTime.value.difference(bedtime.value).inMinutes;

    double efficiency() {
      final tib = timeInBed();
      if (tib <= 0) return 0;
      return totalSleep() / tib;
    }

    Future<void> save() async {
      if (timeInBed() <= 0) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Out-of-bed time must be after bedtime'),
          ),
        );
        return;
      }
      saving.value = true;
      await ref
          .read(diaryRepositoryProvider)
          .insert(
            SleepDiaryEntriesCompanion.insert(
              diaryDate: diaryDate.value,
              bedtime: bedtime.value,
              lightsOut: lightsOut.value,
              wakeTime: wakeTime.value,
              outOfBedTime: outOfBedTime.value,
              sleepLatencyMin: drift.Value(latency.value),
              awakeningsCount: drift.Value(awakenings.value),
              wasoMin: drift.Value(waso.value),
              qualityRating: drift.Value(quality.value),
              moodRating: drift.Value(mood.value),
              adherentToPrescription: drift.Value(adherent.value),
              notes: drift.Value(
                notes.text.trim().isEmpty ? null : notes.text.trim(),
              ),
            ),
          );
      await ref.read(cbtiEngineProvider).onDiaryInserted();
      if (!context.mounted) return;
      if (context.canPop()) {
        context.pop();
      } else {
        context.go('/home');
      }
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Last night')),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            _DateTimeTile(
              label: 'Bedtime (got in bed)',
              value: bedtime.value,
              onTap: () => pickDateTime(bedtime),
            ),
            _DateTimeTile(
              label: 'Lights out',
              value: lightsOut.value,
              onTap: () => pickDateTime(lightsOut),
            ),
            _DateTimeTile(
              label: 'Final wake',
              value: wakeTime.value,
              onTap: () => pickDateTime(wakeTime),
            ),
            _DateTimeTile(
              label: 'Out of bed',
              value: outOfBedTime.value,
              onTap: () => pickDateTime(outOfBedTime),
            ),
            const SizedBox(height: 12),
            _IntSlider(
              label: 'Time to fall asleep (min)',
              value: latency.value,
              min: 0,
              max: 120,
              step: 5,
              onChanged: (v) => latency.value = v,
            ),
            _IntSlider(
              label: 'Awakenings',
              value: awakenings.value,
              min: 0,
              max: 10,
              step: 1,
              onChanged: (v) => awakenings.value = v,
            ),
            _IntSlider(
              label: 'Total time awake during night (min)',
              value: waso.value,
              min: 0,
              max: 180,
              step: 5,
              onChanged: (v) => waso.value = v,
            ),
            const SizedBox(height: 12),
            _RatingRow(
              label: 'Sleep quality',
              value: quality.value,
              onChanged: (v) => quality.value = v,
            ),
            _RatingRow(
              label: 'Mood today',
              value: mood.value,
              onChanged: (v) => mood.value = v,
            ),
            const SizedBox(height: 12),
            SwitchListTile(
              value: adherent.value,
              onChanged: (v) => adherent.value = v,
              title: const Text('Followed prescribed window'),
              subtitle: const Text(
                'Off if you got in bed earlier or got out later than prescribed. Off days are excluded from the algorithm.',
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: notes,
              decoration: const InputDecoration(labelText: 'Notes (optional)'),
              maxLines: 3,
            ),
            const SizedBox(height: 20),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    Text(
                      'Sleep efficiency: ${(efficiency() * 100).toStringAsFixed(0)}%',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Total sleep: ${formatDuration(Duration(minutes: totalSleep().clamp(0, 24 * 60)))} '
                      '· Time in bed: ${formatDuration(Duration(minutes: timeInBed()))}',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            FilledButton(
              onPressed: saving.value ? null : save,
              child: saving.value
                  ? const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Text('Save'),
            ),
            const SizedBox(height: 8),
            TextButton(
              onPressed: () {
                if (context.canPop()) {
                  context.pop();
                } else {
                  context.go('/home');
                }
              },
              child: const Text('Cancel'),
            ),
          ],
        ),
      ),
    );
  }

  static DateTime _at(DateTime base, int h, int m) =>
      DateTime(base.year, base.month, base.day, h, m);
}

class _DateTimeTile extends StatelessWidget {
  final String label;
  final DateTime value;
  final VoidCallback onTap;
  const _DateTimeTile({
    required this.label,
    required this.value,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final wd = [
      'Mon',
      'Tue',
      'Wed',
      'Thu',
      'Fri',
      'Sat',
      'Sun',
    ][value.weekday - 1];
    final dateStr = '$wd ${value.month}/${value.day}';
    final timeStr =
        '${value.hour.toString().padLeft(2, '0')}:${value.minute.toString().padLeft(2, '0')}';
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: ListTile(
        title: Text(label),
        subtitle: Text('$dateStr · $timeStr'),
        trailing: const Icon(Icons.edit_calendar_outlined),
        onTap: onTap,
      ),
    );
  }
}

class _IntSlider extends StatelessWidget {
  final String label;
  final int value;
  final int min;
  final int max;
  final int step;
  final ValueChanged<int> onChanged;
  const _IntSlider({
    required this.label,
    required this.value,
    required this.min,
    required this.max,
    required this.step,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(label, style: Theme.of(context).textTheme.bodyMedium),
                Text('$value', style: Theme.of(context).textTheme.titleMedium),
              ],
            ),
          ),
          Slider(
            value: value.toDouble(),
            min: min.toDouble(),
            max: max.toDouble(),
            divisions: ((max - min) / step).round(),
            label: '$value',
            onChanged: (v) => onChanged(v.round()),
          ),
        ],
      ),
    );
  }
}

class _RatingRow extends StatelessWidget {
  final String label;
  final int value;
  final ValueChanged<int> onChanged;
  const _RatingRow({
    required this.label,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Expanded(
            child: Text(label, style: Theme.of(context).textTheme.bodyLarge),
          ),
          ...List.generate(5, (i) {
            final n = i + 1;
            return IconButton(
              icon: Icon(
                n <= value ? Icons.circle : Icons.circle_outlined,
                size: 22,
              ),
              onPressed: () => onChanged(n),
              padding: const EdgeInsets.symmetric(horizontal: 2),
              constraints: const BoxConstraints(),
              visualDensity: VisualDensity.compact,
            );
          }),
        ],
      ),
    );
  }
}
