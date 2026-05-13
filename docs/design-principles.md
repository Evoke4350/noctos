# noctos design principles

Reread this before adding any feature. The principles are ordered — earlier ones beat later ones when they conflict.

## 1. Prescriptions, not judgments

The app tells the user what to do tonight and *why*. It does not tell them whether last night was good or bad. Show rationale strings verbatim. Never insert a tone of approval or disappointment. The algorithm titrates a window; the user owns the experience.

Concretely:
- No "sleep score" of any kind.
- No emoji reactions on diary entries.
- Sleep efficiency is a number, not a verdict. Show the trend; do not annotate it with adjectives.

## 2. No gamification — orthosomnia is real harm

Streaks, badges, "perfect week" callouts, and reward animations all train the user to optimize the *tracker* instead of *sleep*. The medical literature calls this orthosomnia and it makes insomnia worse.

Concretely:
- No streaks.
- No leaderboard, social, or comparison features.
- No daily push notifications that hype completion. Reminders only.
- "History" shows data, not achievements.

## 3. Adherence is sacred — protect the algorithm

Sleep restriction works because the math is honest about what the user actually did. Non-adherent nights must be flagged and excluded from titration. If we silently fold non-adherent data in, the algorithm prescribes an ever-shrinking window and harms the user.

Concretely:
- Diary form requires an explicit adherence toggle, not buried in advanced.
- Engine code path that excludes non-adherent nights must have tests covering it (currently in `test/sleep_restriction_test.dart` and `test/cbti_engine_test.dart`). Never delete those tests.
- Algorithm floor stays at 5h. Never prescribe less.

## 4. Local-first, no telemetry, no accounts

Data lives on device in SQLite (Drift). Sync, cloud backup, and accounts are out of scope. Export is via file (JSON/CSV) — user controls where it goes. No analytics, no crash reporters that ship data off-device.

Concretely:
- No Firebase, no Crashlytics, no Sentry, no PostHog.
- No "share to friend" features that imply server middleware.
- The only network calls in the app should be zero. Audit this on every dep bump.

## 5. Evidence-based or out

Every recommendation has a citation in the head of whoever wrote it. CBT-I, sleep restriction, stimulus control, two-process model, caffeine half-life, morning bright light — these are decades old and well-replicated. Glycine, melatonin micro-dosing, weighted blankets, ASMR — these are not.

Concretely:
- New features grounded in primary literature, not blog posts.
- If a feature has no strong study behind it, it does not ship.
- Bias toward the small set of interventions that are clinically standard.

## 6. Transparency drives adherence

Users follow protocols they understand. Show the math:
- Why the window changed (the `rationale` string verbatim).
- How efficiency is computed.
- What "adherent" excludes.
- Where caffeine half-life numbers come from.

Concretely:
- Every prescription comes with a one-sentence explanation.
- Every threshold (≥85%, <80%, 5h floor) is in a place a user can read, not buried in code.

## 7. Minimum viable surface

The fewer screens, the better. Each new feature is a maintenance liability and a distraction from the parts that work.

Concretely:
- Current MVP is 12 screens. Adding a 13th requires deleting one.
- "Just one toggle in settings" is how settings screens become unmaintainable.

## 8. Severe insomnia → clinician

The about copy in settings makes this explicit. Do not ever imply this app is a replacement for sleep medicine, polysomnography, or a CBT-I therapist.

Concretely:
- If a user reports severity 9+, surface a "consider seeing a clinician" line.
- Never claim the app diagnoses anything.

## When in doubt

Ask: *would a working clinician roll their eyes at this?* If yes, do not ship it.
