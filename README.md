# noctos

[![ci](../../actions/workflows/ci.yml/badge.svg)](../../actions/workflows/ci.yml)
[![macos](../../actions/workflows/macos.yml/badge.svg)](../../actions/workflows/macos.yml)
[![release](../../actions/workflows/release.yml/badge.svg)](../../actions/workflows/release.yml)
[![License: AGPL v3](https://img.shields.io/badge/License-AGPL_v3-blue.svg)](LICENSE)

An OSS, local-first, AGPLv3 Flutter app that implements the full 6-week CBT-I
(Cognitive Behavioral Therapy for Insomnia) protocol. CBT-I is the first-line
clinical recommendation for chronic insomnia and outperforms hypnotics
long-term — yet no mature open-source app implements it. noctos exists to fill
that gap.

**Status:** v0.1.0 (early). Android + macOS (experimental). No accounts, no telemetry, no cloud.

## What it does

- 6-week structured CBT-I program: assessment → sleep restriction → stimulus
  control overlay → cognitive → hygiene → relapse prevention.
- Sleep diary with bedtime, lights-out, awakenings, WASO, wake, quality,
  mood, **adherence flag**.
- Sleep-restriction titration algorithm: expand window +15 min when rolling
  efficiency ≥ 85%, contract −15 min when < 80%, hold otherwise. 5h floor.
  Non-adherent nights excluded.
- Chronotype quiz (MEQ short form), schedule setup, bedtime/wake window.
- Caffeine log with predicted mg at bedtime (5h half-life decay curve).
- Worry journal with bedtime-window guardrail.
- Daily reminders: wind-down, bedtime, wake, caffeine cutoff.
- Local SQLite via Drift. Export to JSON or CSV.
- **Health Connect (Android, optional):** reads sleep timing, stages,
  heart rate, HRV, and resting HR; displays alongside your diary. Watch
  data is informational only — diary still drives the program. See
  [`docs/health-integration.md`](docs/health-integration.md).

## What it does *not* do

- No scores, streaks, badges. Read [`docs/design-principles.md`](docs/design-principles.md) for why.
- No cloud sync, accounts, or telemetry.
- No iOS build yet (scaffolded; signed builds require Apple Developer cert).
- Not medical advice. Severe insomnia: see a clinician.

## Build

Tested on Linux + JDK 21 + Flutter stable 3.41.9 + Android SDK 36.

```bash
# Toolchain
sudo pacman -S jdk21-openjdk   # or your distro equivalent
# Download Flutter tarball into ~/dev/flutter (NOT AUR)
# Install Android cmdline-tools + platforms;android-36 + build-tools;36.0.0

export JAVA_HOME=/usr/lib/jvm/java-21-openjdk
export ANDROID_HOME="$HOME/Android"
export PATH="$HOME/dev/flutter/bin:$ANDROID_HOME/cmdline-tools/latest/bin:$ANDROID_HOME/platform-tools:$PATH"

flutter doctor                            # must be clean for Android
cd noctos
dart run build_runner build               # generates Drift code
flutter test                              # 32 tests
flutter build apk --release --split-per-abi
```

Output: `build/app/outputs/flutter-apk/app-arm64-v8a-release.apk`.

### macOS build

Requires macOS + Xcode. Linux/Windows cannot build the macOS target — CI does it on `macos-latest`.

```bash
flutter config --enable-macos-desktop
flutter pub get
dart run build_runner build
flutter build macos --release
open build/macos/Build/Products/Release/noctos.app
```

CI builds an unsigned `.app` zip on every push to `main` and attaches it to GitHub Releases for tagged builds. For distribution outside the Mac App Store the app needs Developer ID signing + notarization (not yet configured).

## Release signing

The default Flutter release config signs with the debug keystore — fine for
sideloading, not for Play Store / F-Droid reproducible builds.

To sign with your own key:

```bash
keytool -genkey -v \
  -keystore ~/.android/noctos-upload.jks \
  -keyalg RSA -keysize 2048 -validity 10000 \
  -alias upload
```

Create `android/key.properties` (gitignored):

```
storePassword=<your password>
keyPassword=<your password>
keyAlias=upload
storeFile=/home/you/.android/noctos-upload.jks
```

Then update `android/app/build.gradle.kts` `signingConfigs.release` to read
from those properties.

## Project layout

```
lib/
  main.dart, app.dart
  core/                 theme, router, time helpers
  data/
    db/                 Drift schema + generated code + providers
    repositories/       one per aggregate (schedule, diary, cbti, caffeine, worry)
  domain/
    cbti/               protocol, sleep_restriction, engine
    caffeine/           half-life math
    chronotype/         MEQ short-form quiz
  features/             one folder per screen group
  services/
    notifications/      flutter_local_notifications scheduler
    export/             JSON/CSV exporter
docs/
  design-principles.md  reread before adding features
test/                   unit tests against in-memory Drift
```

## Tests

```bash
flutter test
```

32 tests at v0.1.0:
- 15 covering the sleep-restriction algorithm (safety-critical).
- 4 integration tests of `CBTIEngine` against in-memory SQLite.
- 10 caffeine half-life tests.
- 3 time-helper tests.

## License

AGPLv3 — see [LICENSE](LICENSE). If you run a modified version as a network
service, you must release source.

## Contributing

See [CONTRIBUTING.md](CONTRIBUTING.md). Short version: read
`docs/design-principles.md` first.
