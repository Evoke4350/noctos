import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../data/repositories/cbti_week_repository.dart';
import '../../domain/cbti/protocol.dart';

class ProgramOverviewScreen extends ConsumerWidget {
  const ProgramOverviewScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentAsync = ref.watch(currentCbtiWeekProvider);
    final timelinePhases = cbtiProtocol
        .where((s) => s.phase != CBTIPhase.stimulusControl)
        .toList();

    return Scaffold(
      appBar: AppBar(title: const Text('Program')),
      body: SafeArea(
        child: currentAsync.when(
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (e, _) => Center(child: Text('Error: $e')),
          data: (current) {
            final currentPhase = current == null
                ? CBTIPhase.assessment
                : phaseFromId(current.phaseId);
            return ListView.separated(
              padding: const EdgeInsets.all(20),
              itemCount: timelinePhases.length + 1,
              separatorBuilder: (_, __) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                if (index == 0) {
                  return Text(
                    '6-week CBT-I program. The algorithm prescribes a sleep window weekly; you log diary, it adjusts.',
                    style: Theme.of(context).textTheme.bodyLarge,
                  );
                }
                final spec = timelinePhases[index - 1];
                final isCurrent = spec.phase == currentPhase;
                return _PhaseCard(
                  spec: spec,
                  isCurrent: isCurrent,
                  onTap: () => context.push('/program/${spec.approxWeekIndex}'),
                );
              },
            );
          },
        ),
      ),
    );
  }
}

class _PhaseCard extends StatelessWidget {
  final CBTIPhaseSpec spec;
  final bool isCurrent;
  final VoidCallback onTap;

  const _PhaseCard({
    required this.spec,
    required this.isCurrent,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Card(
      color: isCurrent ? scheme.primary.withValues(alpha: 0.15) : null,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: isCurrent
            ? BorderSide(color: scheme.primary, width: 1)
            : BorderSide.none,
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CircleAvatar(
                backgroundColor: isCurrent
                    ? scheme.primary
                    : scheme.surfaceContainerHigh,
                foregroundColor: isCurrent
                    ? scheme.onPrimary
                    : scheme.onSurfaceVariant,
                child: Text('${spec.approxWeekIndex + 1}'),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      spec.title,
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 2),
                    Text(
                      spec.subtitle,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: scheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
              const Icon(Icons.chevron_right, size: 20),
            ],
          ),
        ),
      ),
    );
  }
}
