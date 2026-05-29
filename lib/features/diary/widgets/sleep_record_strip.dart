import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../data/repositories/sleep_record_repository.dart';

class SleepRecordStrip extends ConsumerWidget {
  const SleepRecordStrip({super.key, required this.diaryDate});

  final DateTime diaryDate;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final async = ref.watch(sleepRecordForNightProvider(diaryDate));
    return async.when(
      loading: () => const SizedBox.shrink(),
      error: (e, st) => const SizedBox.shrink(),
      data: (record) {
        if (record == null) return const SizedBox.shrink();
        final fmt = DateFormat('h:mma');
        final hours = record.totalMinutes ~/ 60;
        final mins = record.totalMinutes % 60;
        final source = [
          record.sourceDevice,
          record.sourceApp,
        ].where((s) => s != null && (s).isNotEmpty).join(' · ');
        return InkWell(
          onTap: () => GoRouter.of(
            context,
          ).push('/diary/${diaryDate.toIso8601String()}/sleep-record'),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
            child: Row(
              children: [
                const Icon(Icons.watch, size: 16),
                const SizedBox(width: 8),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${fmt.format(record.sessionStart).toLowerCase()} → '
                        '${fmt.format(record.sessionEnd).toLowerCase()} · '
                        '${hours}h ${mins}m',
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                      if (source.isNotEmpty)
                        Text(
                          '$source · tap for detail',
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                    ],
                  ),
                ),
                const Icon(Icons.chevron_right, size: 18),
              ],
            ),
          ),
        );
      },
    );
  }
}
