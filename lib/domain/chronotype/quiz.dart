class MeqQuestion {
  final String prompt;
  final List<String> options; // index 0..4
  const MeqQuestion(this.prompt, this.options);
}

const meqQuestions = <MeqQuestion>[
  MeqQuestion(
    'If entirely free to plan your day, what time would you get up?',
    [
      'After 10:30 AM',
      '08:30–10:30 AM',
      '07:30–08:30 AM',
      '06:30–07:30 AM',
      'Before 06:30 AM',
    ],
  ),
  MeqQuestion(
    'How easy is it for you to get out of bed in the morning?',
    [
      'Very difficult',
      'Difficult',
      'Average',
      'Fairly easy',
      'Very easy',
    ],
  ),
  MeqQuestion(
    'During the first half hour after waking, how alert do you feel?',
    [
      'Very groggy',
      'Slow to wake',
      'Fairly alert',
      'Alert',
      'Very alert',
    ],
  ),
  MeqQuestion(
    'In the evening, what time do you feel tired and need to sleep?',
    [
      'After 02:00 AM',
      '00:30–02:00 AM',
      '22:30–00:30',
      '21:30–22:30',
      'Before 21:30',
    ],
  ),
  MeqQuestion(
    'If you went to bed at 23:00, how tired would you feel?',
    [
      'Not tired at all',
      'A little tired',
      'Somewhat tired',
      'Tired',
      'Very tired',
    ],
  ),
];

class ChronotypeResult {
  final int score; // 5 (extreme evening) .. 25 (extreme morning)
  final String category; // evening | intermediate | morning
  final String suggestion;
  const ChronotypeResult(this.score, this.category, this.suggestion);
}

ChronotypeResult scoreChronotype(List<int> answersZeroIndexed) {
  // each answer 0..4 → +1..+5
  final score = answersZeroIndexed.fold<int>(0, (a, b) => a + b + 1);
  if (score <= 10) {
    return ChronotypeResult(
      score,
      'evening',
      'Late chronotype. Natural bedtime later; prescription will anchor on a fixed (but realistic) wake time.',
    );
  } else if (score <= 18) {
    return ChronotypeResult(
      score,
      'intermediate',
      'Intermediate chronotype. Bedtime and wake flexibility is moderate.',
    );
  } else {
    return ChronotypeResult(
      score,
      'morning',
      'Early chronotype. Earlier prescribed wake works well; avoid late evening screens.',
    );
  }
}
