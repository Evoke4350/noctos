import 'package:drift/drift.dart' as drift;
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../core/time.dart';
import '../../data/db/database.dart';
import '../../data/repositories/schedule_repository.dart';
import 'onboarding_draft.dart';

class ScheduleSetupScreen extends HookConsumerWidget {
  const ScheduleSetupScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final draft = ref.watch(onboardingDraftProvider);
    final defaults = _defaultsFor(draft.chronotypeCategory);
    final wake = useState<TimeOfDay>(draft.fixedWake ?? defaults.$1);
    final bed = useState<TimeOfDay>(draft.initialBedtime ?? defaults.$2);
    final saving = useState(false);

    Future<void> pickTime(ValueNotifier<TimeOfDay> target) async {
      final picked = await showTimePicker(
        context: context,
        initialTime: target.value,
      );
      if (picked != null) target.value = picked;
    }

    Future<void> save() async {
      saving.value = true;
      final tib = _tibMinutes(bed.value, wake.value);
      ref.read(onboardingDraftProvider.notifier).setSchedule(wake.value, bed.value);
      final entry = UserSchedulesCompanion.insert(
        fixedWakeMinutesOfDay: minutesOfDay(wake.value),
        currentBedtimeMinutesOfDay: minutesOfDay(bed.value),
        currentTibMinutes: drift.Value(tib),
        chronotypeScore: drift.Value(draft.chronotypeScore),
        chronotypeCategory: drift.Value(draft.chronotypeCategory),
        insomniaTypes: drift.Value(draft.insomniaTypes.join(',')),
        insomniaSeverity: drift.Value(draft.severity),
      );
      await ref.read(scheduleRepositoryProvider).create(entry);
      if (!context.mounted) return;
      context.go('/home');
    }

    final tib = _tibMinutes(bed.value, wake.value);

    return Scaffold(
      appBar: AppBar(title: const Text('Your schedule')),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            Text(
              'Pick the wake time you can hold every day, including weekends. '
              'Consistent wake time anchors your circadian rhythm — the single most important rule.',
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            const SizedBox(height: 24),
            Card(
              child: ListTile(
                title: const Text('Fixed wake time'),
                subtitle: Text(formatTimeOfDay(wake.value)),
                trailing: const Icon(Icons.access_time),
                onTap: () => pickTime(wake),
              ),
            ),
            const SizedBox(height: 12),
            Card(
              child: ListTile(
                title: const Text('Initial bedtime'),
                subtitle: Text(formatTimeOfDay(bed.value)),
                trailing: const Icon(Icons.bedtime_outlined),
                onTap: () => pickTime(bed),
              ),
            ),
            const SizedBox(height: 16),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Time in bed'),
                    Text(formatDuration(Duration(minutes: tib)),
                        style: Theme.of(context).textTheme.titleMedium),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 32),
            FilledButton(
              onPressed: saving.value ? null : save,
              child: saving.value
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Text('Start tracking'),
            ),
          ],
        ),
      ),
    );
  }

  (TimeOfDay, TimeOfDay) _defaultsFor(String? category) {
    switch (category) {
      case 'morning':
        return (const TimeOfDay(hour: 6, minute: 30), const TimeOfDay(hour: 22, minute: 30));
      case 'evening':
        return (const TimeOfDay(hour: 8, minute: 0), const TimeOfDay(hour: 0, minute: 0));
      default:
        return (const TimeOfDay(hour: 7, minute: 0), const TimeOfDay(hour: 23, minute: 0));
    }
  }

  int _tibMinutes(TimeOfDay bed, TimeOfDay wake) {
    final bedM = minutesOfDay(bed);
    final wakeM = minutesOfDay(wake);
    var tib = wakeM - bedM;
    if (tib <= 0) tib += 24 * 60;
    return tib;
  }
}
