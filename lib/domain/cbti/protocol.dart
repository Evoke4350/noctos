/// Static 6-week CBT-I protocol. Single source of truth for the program.
///
/// Phases run roughly:
///   assessment → sr_baseline → sr_active → stimulus_control →
///   cognitive → hygiene → relapse_prevention.
///
/// `stimulus_control` rules run from week 2 onwards as an overlay
/// (advisory + notification triggers), not a distinct "complete" gate.

enum CBTIPhase {
  assessment,
  srBaseline,
  srActive,
  stimulusControl,
  cognitive,
  hygiene,
  relapsePrevention,
}

class CBTIPhaseSpec {
  final CBTIPhase phase;
  final String title;
  final String subtitle;

  /// Plain-text rationale (markdown-light). Shown on week detail.
  final String rationale;

  /// Daily checklist items the user should keep up during this phase.
  final List<String> daily;

  /// Minimum days needed before the phase can advance.
  final int minDays;

  /// Approximate week index (0-based) where this phase typically sits.
  /// Used to render the 6-week timeline.
  final int approxWeekIndex;

  const CBTIPhaseSpec({
    required this.phase,
    required this.title,
    required this.subtitle,
    required this.rationale,
    required this.daily,
    required this.minDays,
    required this.approxWeekIndex,
  });
}

const cbtiProtocol = <CBTIPhaseSpec>[
  CBTIPhaseSpec(
    phase: CBTIPhase.assessment,
    title: 'Week 1 · Baseline',
    subtitle: 'Track 7 nights before anything changes',
    rationale:
        'CBT-I starts with data, not changes. Before adjusting anything, we need a '
        'week of honest sleep diaries to compute your current sleep efficiency. '
        'Sleep as you normally would. Do not try to optimize.',
    daily: [
      'Log diary every morning (within 15 minutes of getting up)',
      'Keep a consistent rough wake time, but do not force it yet',
      'No new caffeine or evening routine changes this week',
    ],
    minDays: 7,
    approxWeekIndex: 0,
  ),
  CBTIPhaseSpec(
    phase: CBTIPhase.srBaseline,
    title: 'Week 2 · First prescription',
    subtitle: 'Sleep restriction begins',
    rationale:
        'Using your baseline diary, the app prescribes a sleep window: '
        'a fixed wake time and a bedtime later than you are used to. '
        'You only get in bed inside this window. Restricting time-in-bed '
        'increases sleep pressure, consolidates sleep, and raises efficiency. '
        'The window will expand once efficiency is high. Never below 5h.',
    daily: [
      'Stay out of bed until prescribed bedtime — even if tired',
      'Get up at fixed wake time every day, including weekends',
      'No naps during the day',
      'Log diary each morning',
    ],
    minDays: 7,
    approxWeekIndex: 1,
  ),
  CBTIPhaseSpec(
    phase: CBTIPhase.srActive,
    title: 'Weeks 2–4 · Titration',
    subtitle: 'Window adjusts weekly based on efficiency',
    rationale:
        'Each week the algorithm reviews your rolling 5–7 day efficiency. '
        'If ≥ 85%, the window expands by 15 min. If < 80%, it contracts by 15 min. '
        'Between those bounds, it holds. Non-adherent nights are excluded — '
        'they tell the algorithm nothing about your true sleep need.',
    daily: [
      'Maintain prescribed window strictly',
      'If awake in bed > 20 min, get out (see stimulus control)',
      'Log diary including the adherence flag honestly',
    ],
    minDays: 14,
    approxWeekIndex: 2,
  ),
  CBTIPhaseSpec(
    phase: CBTIPhase.stimulusControl,
    title: 'Stimulus control (overlay)',
    subtitle: 'Rebuild the bed = sleep association',
    rationale:
        'Insomnia trains the brain that bed = wakefulness and worry. '
        'Stimulus control reverses this conditioning. Bed is for sleep and sex only. '
        'No phones, reading, TV, or worrying in bed. If you cannot sleep within '
        '~20 minutes, get up, sit in dim light somewhere else, and only return '
        'when sleepy. Apply these rules continuously alongside sleep restriction.',
    daily: [
      'Bed = sleep + sex only',
      'Awake > 20 min → get up, dim light, return when sleepy',
      'Fixed wake time always, including weekends',
      'No daytime naps',
    ],
    minDays: 0,
    approxWeekIndex: 2,
  ),
  CBTIPhaseSpec(
    phase: CBTIPhase.cognitive,
    title: 'Week 4 · Thoughts about sleep',
    subtitle: 'Untangle catastrophizing and effort',
    rationale:
        'For many, the loudest part of insomnia is the thought "I will not sleep '
        'and tomorrow will be ruined." That belief raises arousal and prolongs '
        'wakefulness. This week introduces simple cognitive techniques: '
        'naming the worry, reality-testing it, and using the worry-journal '
        'window (set 1–2 hours before bed) so the mind has somewhere to put '
        'the loop other than the pillow.',
    daily: [
      'Worry journal entry at a fixed pre-bed time (not in bed)',
      'Notice and label catastrophic sleep thoughts when they arise',
      'Continue diary + restricted window',
    ],
    minDays: 5,
    approxWeekIndex: 3,
  ),
  CBTIPhaseSpec(
    phase: CBTIPhase.hygiene,
    title: 'Week 5 · Hygiene & environment',
    subtitle: 'The small inputs that compound',
    rationale:
        'Sleep hygiene by itself is weak medicine — that is why it is week 5, '
        'not week 1. But layered onto a working schedule it amplifies gains. '
        'Cool dark room, last caffeine ~10 hours before bed, no alcohol within '
        '3 hours of bed, morning bright light within 30 minutes of waking.',
    daily: [
      'Caffeine cutoff applied consistently',
      'Morning light exposure (≥ 10 min) within 30 min of wake',
      'Cool, dark, quiet bedroom — verify each evening',
    ],
    minDays: 5,
    approxWeekIndex: 4,
  ),
  CBTIPhaseSpec(
    phase: CBTIPhase.relapsePrevention,
    title: 'Week 6 · Keep what works',
    subtitle: 'Build a plan for the next bad week',
    rationale:
        'Insomnia returns under stress. The point of week 6 is to write down '
        'your own playbook: which rules you will re-apply when sleep slips '
        'for ≥ 3 nights in a row, and which you can ease when sleep is solid. '
        'Re-running 1–2 weeks of sleep restriction is the standard rescue.',
    daily: [
      'Review which rules you can relax and which to keep permanently',
      'Write a "bad week protocol" note in settings',
      'Continue diary at lower cadence',
    ],
    minDays: 5,
    approxWeekIndex: 5,
  ),
];

CBTIPhaseSpec specFor(CBTIPhase phase) =>
    cbtiProtocol.firstWhere((s) => s.phase == phase);

String phaseId(CBTIPhase p) => p.name;

CBTIPhase phaseFromId(String id) =>
    CBTIPhase.values.firstWhere((p) => p.name == id);
