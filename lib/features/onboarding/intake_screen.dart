import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'onboarding_draft.dart';

class IntakeScreen extends ConsumerWidget {
  const IntakeScreen({super.key});

  static const _types = {
    'initial': 'Trouble falling asleep',
    'middle': 'Waking through the night',
    'terminal': 'Waking too early',
    'nonrestorative': 'Sleep feels unrefreshing',
  };

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final draft = ref.watch(onboardingDraftProvider);
    final notifier = ref.read(onboardingDraftProvider.notifier);

    return Scaffold(
      appBar: AppBar(title: const Text('What brings you here?')),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            Text(
              'Tell us about your sleep complaint. This stays on your device.',
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            const SizedBox(height: 24),
            Text(
              'Which describes you?',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            ..._types.entries.map((e) {
              final selected = draft.insomniaTypes.contains(e.key);
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 4),
                child: CheckboxListTile(
                  value: selected,
                  onChanged: (v) {
                    final set = Set<String>.from(draft.insomniaTypes);
                    if (v == true) {
                      set.add(e.key);
                    } else {
                      set.remove(e.key);
                    }
                    notifier.setInsomniaTypes(set);
                  },
                  title: Text(e.value),
                  controlAffinity: ListTileControlAffinity.leading,
                ),
              );
            }),
            const SizedBox(height: 24),
            Text(
              'How disruptive is this on a typical day?',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                const Text('1'),
                Expanded(
                  child: Slider(
                    value: draft.severity.toDouble(),
                    min: 1,
                    max: 10,
                    divisions: 9,
                    label: draft.severity.toString(),
                    onChanged: (v) => notifier.setSeverity(v.round()),
                  ),
                ),
                const Text('10'),
              ],
            ),
            Center(
              child: Text(
                'Severity: ${draft.severity}/10',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ),
            const SizedBox(height: 32),
            FilledButton(
              onPressed: draft.insomniaTypes.isEmpty
                  ? null
                  : () => context.go('/onboarding/chronotype'),
              child: const Text('Continue'),
            ),
            const SizedBox(height: 8),
            Text(
              'This app is not medical advice. CBT-I works best alongside a clinician for severe insomnia.',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
