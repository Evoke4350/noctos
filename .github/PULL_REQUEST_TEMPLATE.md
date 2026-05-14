<!-- Read CONTRIBUTING.md and docs/design-principles.md before opening. -->

## What

<!-- One-line summary. -->

## Why

<!-- Cite issue # or evidence. CBT-I algorithm changes need clinical justification. -->

## Checklist

- [ ] `flutter analyze` clean
- [ ] `flutter test` passes
- [ ] `flutter build apk --debug` succeeds
- [ ] New domain logic has unit tests
- [ ] Algorithm change has full branch coverage
- [ ] DB schema change includes migration + `schemaVersion` bump
- [ ] No telemetry, scores, streaks, gamification, or cloud sync introduced
- [ ] No new runtime permissions added without justification
