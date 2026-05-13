# Contributing to noctos

Thanks for considering a contribution. This project is small and opinionated.

## Read first

1. [`docs/design-principles.md`](docs/design-principles.md) — non-negotiable guardrails. Most rejected PRs are rejected here.
2. The CBT-I literature. If you have not read at least Morin & Espie's *Insomnia: A Clinical Guide to Assessment and Treatment*, please defer.

## Ground rules

- **No telemetry, ever.** Not crash reporters, not analytics, not "anonymous diagnostics."
- **No scores, streaks, badges, gamification.** Orthosomnia is real harm.
- **Adherence is sacred.** The algorithm depends on honest non-adherence flags. Code paths that exclude non-adherent nights must remain tested.
- **5h floor on prescribed time-in-bed.** This is a CBT-I standard, not negotiable.
- **Local-first.** Data does not leave the device unless the user exports a file.

## Development setup

See [README.md](README.md) for the toolchain. After clone:

```bash
flutter pub get
dart run build_runner build
flutter test
```

## Before opening a PR

- `flutter analyze` reports zero errors.
- `flutter test` passes.
- `flutter build apk --debug` succeeds.
- New domain logic has unit tests. Algorithm changes have full branch coverage.
- New tables get a migration step in `lib/data/db/database.dart` and a `schemaVersion` bump.

## What gets merged

- Bug fixes for the sleep-restriction algorithm, with tests demonstrating the bug.
- New evidence-based CBT-I features (e.g. sleep compression as gentler alternative to restriction).
- Accessibility improvements.
- Performance fixes.
- Translations (once an `intl` plan lands).

## What does not get merged

- "Sleep score" features.
- Cloud sync, social, comparison.
- Sleep stage estimation from wearables (out of scope, low accuracy).
- Supplements, nootropics, "alternatives to CBT-I."
- Features grounded in pop-sci blog posts rather than peer-reviewed work.

## Commit style

- Imperative present tense, short subject ("Add caffeine cutoff config").
- Body explains *why* if non-obvious. Keep under ~72 char wrap.
- One logical change per commit.

## License

By contributing, you agree your contribution is licensed under AGPLv3 — same as the rest of the project.
