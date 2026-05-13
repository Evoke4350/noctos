import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../domain/chronotype/quiz.dart';
import 'onboarding_draft.dart';

class ChronotypeQuizScreen extends HookConsumerWidget {
  const ChronotypeQuizScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final answers = useState<List<int?>>(List.filled(meqQuestions.length, null));
    final allAnswered = !answers.value.contains(null);
    final result = allAnswered
        ? scoreChronotype(answers.value.cast<int>())
        : null;

    return Scaffold(
      appBar: AppBar(title: const Text('Chronotype')),
      body: SafeArea(
        child: ListView.separated(
          padding: const EdgeInsets.all(20),
          itemCount: meqQuestions.length + 2,
          separatorBuilder: (_, __) => const SizedBox(height: 20),
          itemBuilder: (context, index) {
            if (index == 0) {
              return Text(
                "Quick 5-question quiz. Your answers shape your starting prescription.",
                style: Theme.of(context).textTheme.bodyLarge,
              );
            }
            if (index <= meqQuestions.length) {
              final q = meqQuestions[index - 1];
              return Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('${index}. ${q.prompt}',
                          style: Theme.of(context).textTheme.titleMedium),
                      const SizedBox(height: 8),
                      ...List.generate(q.options.length, (i) {
                        return RadioListTile<int>(
                          value: i,
                          groupValue: answers.value[index - 1],
                          onChanged: (v) {
                            final next = [...answers.value];
                            next[index - 1] = v;
                            answers.value = next;
                          },
                          title: Text(q.options[i]),
                          dense: true,
                        );
                      }),
                    ],
                  ),
                ),
              );
            }
            // footer button + result
            return Column(
              children: [
                if (result != null)
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Chronotype: ${result.category}',
                            style: Theme.of(context).textTheme.titleLarge,
                          ),
                          const SizedBox(height: 4),
                          Text('Score: ${result.score} / 25',
                              style: Theme.of(context).textTheme.bodyMedium),
                          const SizedBox(height: 8),
                          Text(result.suggestion),
                        ],
                      ),
                    ),
                  ),
                const SizedBox(height: 12),
                FilledButton(
                  onPressed: allAnswered
                      ? () {
                          ref
                              .read(onboardingDraftProvider.notifier)
                              .setChronotype(result!.score, result.category);
                          context.go('/onboarding/schedule');
                        }
                      : null,
                  child: const Text('Continue'),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
