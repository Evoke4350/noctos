import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../core/time.dart';
import '../../data/db/database.dart';
import '../../data/repositories/schedule_repository.dart';
import '../../data/repositories/worry_repository.dart';

class WorryJournalScreen extends ConsumerWidget {
  const WorryJournalScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final entries = ref.watch(worryStreamProvider);
    final schedule = ref.watch(scheduleProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Worry journal')),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showAddSheet(context),
        icon: const Icon(Icons.edit),
        label: const Text('Entry'),
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 100),
          children: [
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Park the loop here, not in bed.',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      schedule.maybeWhen(
                        data: (s) {
                          if (s == null) return 'Write 1–2 hours before bedtime.';
                          final bed = timeOfDayFromMinutes(s.currentBedtimeMinutesOfDay);
                          final cutoff = timeOfDayFromMinutes(
                            (s.currentBedtimeMinutesOfDay - 60) % (24 * 60),
                          );
                          return 'Best window: ${formatTimeOfDay(cutoff)} — ${formatTimeOfDay(bed)}. '
                              'Not in bed.';
                        },
                        orElse: () => 'Write 1–2 hours before bedtime.',
                      ),
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            entries.when(
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (e, _) => Center(child: Text('Error: $e')),
              data: (rows) {
                if (rows.isEmpty) {
                  return Center(
                    child: Padding(
                      padding: const EdgeInsets.all(24),
                      child: Text(
                        'No entries yet.',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: Theme.of(context).colorScheme.onSurfaceVariant,
                            ),
                      ),
                    ),
                  );
                }
                return Column(
                  children: rows.map((e) => _Tile(entry: e, ref: ref)).toList(),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showAddSheet(BuildContext context) {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      builder: (ctx) => Padding(
        padding: EdgeInsets.only(bottom: MediaQuery.of(ctx).viewInsets.bottom),
        child: const _AddSheet(),
      ),
    );
  }
}

class _Tile extends StatelessWidget {
  final WorryJournalEntry entry;
  final WidgetRef ref;
  const _Tile({required this.entry, required this.ref});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Card(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 12, 8, 12),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Checkbox(
                value: entry.resolved,
                onChanged: (v) => ref
                    .read(worryRepositoryProvider)
                    .setResolved(entry.id, v ?? false),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      entry.worry,
                      style: TextStyle(
                        decoration: entry.resolved ? TextDecoration.lineThrough : null,
                        color: entry.resolved ? scheme.onSurfaceVariant : scheme.onSurface,
                      ),
                    ),
                    if (entry.nextAction != null && entry.nextAction!.isNotEmpty) ...[
                      const SizedBox(height: 4),
                      Text(
                        '→ ${entry.nextAction}',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: scheme.onSurfaceVariant,
                            ),
                      ),
                    ],
                    const SizedBox(height: 4),
                    Text(
                      _formatDate(entry.enteredAt),
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: scheme.onSurfaceVariant,
                            fontSize: 11,
                          ),
                    ),
                  ],
                ),
              ),
              IconButton(
                icon: const Icon(Icons.delete_outline, size: 20),
                onPressed: () =>
                    ref.read(worryRepositoryProvider).delete(entry.id),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _formatDate(DateTime d) {
    return '${d.month}/${d.day} ${d.hour.toString().padLeft(2, '0')}:${d.minute.toString().padLeft(2, '0')}';
  }
}

class _AddSheet extends HookConsumerWidget {
  const _AddSheet();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final worry = useTextEditingController();
    final action = useTextEditingController();
    final saving = useState(false);

    Future<void> save() async {
      if (worry.text.trim().isEmpty) return;
      saving.value = true;
      await ref.read(worryRepositoryProvider).insert(
            enteredAt: DateTime.now(),
            worry: worry.text.trim(),
            nextAction: action.text.trim().isEmpty ? null : action.text.trim(),
          );
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
            Text('What is on your mind?',
                style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 16),
            TextField(
              controller: worry,
              autofocus: true,
              maxLines: 3,
              decoration: const InputDecoration(
                labelText: 'Worry',
                hintText: 'Name the loop',
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: action,
              maxLines: 2,
              decoration: const InputDecoration(
                labelText: 'Next action (optional)',
                hintText: 'Smallest concrete step',
              ),
            ),
            const SizedBox(height: 20),
            FilledButton(
              onPressed: saving.value ? null : save,
              child: const Text('Park it'),
            ),
          ],
        ),
      ),
    );
  }
}
