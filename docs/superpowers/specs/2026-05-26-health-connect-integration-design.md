# Health Connect Integration — Design

**Status:** Approved, awaiting implementation plan
**Date:** 2026-05-26
**Scope:** Android only (v1). iOS HealthKit deferred to separate spec (v1.1).

## Goal

Read sleep, heart rate, HRV, and resting heart rate from Health Connect and display alongside the user's CBT-I sleep diary. Watch data is purely informational. The sleep-restriction algorithm continues to consume diary data only.

## Non-goals

- iOS HealthKit (own spec, v1.1)
- Web target (no Health API in browser; HC section hidden on web build)
- Write-back to Health Connect
- Background sync / WorkManager / alarms
- Notifications triggered by watch data
- Changes to the CBT-I sleep-restriction algorithm
- Backfill of historical data (going-forward sync only)
- Multi-source reconciliation beyond simple dedup
- Stage / HR / HRV trend charts (possible v1.1)
- Partner / multi-profile

## Key product decisions

1. **Diary wins.** Algorithm input is the diary. Watch data never alters titration. Source: CBT-I literature (Spielman et al., 1987; Edinger & Carney, 2014) — actigraphy systematically overestimates sleep because wrist sensors cannot distinguish quiet wakefulness from sleep.
2. **Signals (read-only):** sleep sessions (with stages), heart rate, HRV (RMSSD), resting heart rate.
3. **Going-forward sync only.** No historical backfill on first connect. Stricter data minimization, simpler UX.
4. **No write-back.** noctos does not push anything into Health Connect.
5. **Foreground-only sync.** No background workers. Triggers: home/diary screen open, app resume, manual "Sync now" button.
6. **Onboarding placement:** Settings toggle from day 1. One-time mid-program nudge once `currentWeek >= 2`.
7. **Package choice:** [`health`](https://pub.dev/packages/health) (^11.x) — cross-platform abstraction, future-proofs iOS work.

## Architecture

### Module layout

```
lib/
  data/
    db/
      tables/
        sleep_records.dart          NEW
      database.dart                 schema 3 → 4, migration adds sleep_records
    repositories/
      sleep_record_repository.dart  NEW (CRUD + dedup by sessionStart)
  services/
    health/                         NEW directory
      health_connect_service.dart   permission, availability, raw queries
      sleep_record_sync.dart        orchestrator (HC → domain model → repo)
      models.dart                   SleepStage enum, SleepRecord DTO, source
      providers.dart                Riverpod providers
  features/
    diary/
      widgets/
        sleep_record_strip.dart     NEW (decoration under diary entry)
      sleep_record_detail_screen.dart  NEW (full breakdown on tap)
    settings/
      widgets/
        health_connect_section.dart NEW (toggle, status, revoke help)
```

### Data model — new Drift table

```dart
// lib/data/db/tables/sleep_records.dart
class SleepRecords extends Table {
  IntColumn  get id              => integer().autoIncrement()();
  DateTimeColumn get sessionStart => dateTime()();
  DateTimeColumn get sessionEnd   => dateTime()();
  IntColumn  get totalMinutes    => integer()();
  TextColumn get stagesJson      => text().nullable()();   // [{startMs,endMs,stage}]
  RealColumn get hrAvgBpm        => real().nullable()();
  RealColumn get hrvAvgMs        => real().nullable()();   // RMSSD
  RealColumn get restingHrBpm    => real().nullable()();
  TextColumn get sourceApp       => text().nullable()();   // "Mi Fitness"
  TextColumn get sourceDevice    => text().nullable()();   // "Mi Band 7"
  DateTimeColumn get syncedAt    => dateTime()();

  @override
  List<Set<Column>> get uniqueKeys => [{sessionStart}];
}
```

`stagesJson` blob (not separate table) — stage timelines read together, never queried independently. Keeps schema flat.

### Schema migration

`schemaVersion: 3 → 4`:

```dart
if (from < 4) await m.createTable(sleepRecords);
```

### Sync orchestrator — foreground-only, idempotent

On first permission grant, persist `firstConnectedAt = now()` to `shared_preferences`. Used as floor for sync window so first run does not backfill historical data.

```
SleepRecordSync.syncRecent()
  1. if !HC available                       → no-op
  2. if !hasPermissions                     → no-op
  3. if (now() - lastSyncAttemptAt) < 60s   → no-op (throttle)
  4. lastSyncAttemptAt = now()
  5. windowEnd   = now()
     windowStart = max(
                     lastSyncedSessionEnd ?? firstConnectedAt,
                     firstConnectedAt,
                     now() - 7d
                   )
     // first run: windowStart == firstConnectedAt ≈ now() → empty result
     // steady state: windowStart == lastSyncedSessionEnd
     // catch-up after long absence: capped at now() - 7d
  6. raw = HealthConnectService.readSleepSessions(windowStart, windowEnd)
  7. for each session:
       hrSamples  = readHeartRate(session.start, session.end)
       hrvSamples = readHRV(session.start, session.end)
       restingHr  = readRestingHeartRate(session.end - 24h, session.end)
       record = SleepRecord.fromHealth(session, hrSamples, hrvSamples, restingHr)
       repo.upsertByNaturalKey(record)
```

**Triggers:**
- Home/diary screen `initState`
- App resume from background (with throttle, so rapid foreground/background cycling is harmless)
- Explicit "Sync now" button in Settings → Health Connect section (bypasses throttle)

No background workers. No `WorkManager`. No alarms.

**HC record types read:**
- `SleepSessionRecord`
- `HeartRateRecord`
- `HeartRateVariabilityRmssdRecord`
- `RestingHeartRateRecord`

### Riverpod wiring

- `healthConnectServiceProvider` — singleton service
- `healthConnectStatusProvider` — StreamProvider yielding `notInstalled | available | needsPermissions | granted | partial | denied | error`
- `sleepRecordRepositoryProvider` — DB repo
- `sleepRecordForDateProvider.family(DateTime)` — yields nightly record matched to diary entry

## UI

### Diary screen — sleep record strip

Slots under existing diary entry card on home + history detail. Three states:

**State 1 — HC connected, record exists for night**

```
┌─────────────────────────────────────┐
│ Your diary                          │
│ 11:30pm → 6:15am · 6h 45m           │
├─────────────────────────────────────┤
│ ⌚ 11:42pm → 6:08am · 6h 26m        │
│    Mi Band 7 · tap for detail   ›   │
└─────────────────────────────────────┘
```

**State 2 — HC connected, no record (no wear)**

Strip omitted entirely. No empty state, no nag.

**State 3 — HC not connected**

Strip omitted. Settings has toggle. Week-2 nudge handles the prompt.

### Detail screen on tap

```
Tue 26 May · watch data

Session       11:42pm → 6:08am (6h 26m)
Source        Mi Band 7 via Mi Fitness

Stages
┌────────────────────────────────────┐
│ ▓▓░░██▓░██▓▓░░██▓▓▓░░██▓▓▓░░       │
└────────────────────────────────────┘
   ░ Awake 22m  ▓ Light 3h 18m
   █ Deep 1h 06m  ◆ REM 1h 40m

Heart rate     avg 58 bpm · resting 54
HRV (RMSSD)    42 ms

—
Watch data informational. Diary drives program.
```

Footer line shown once per detail screen. Quiet, not banner.

### Settings — Health Connect section

```
Health Connect
○ Connected (last sync 2 min ago)
  [ Sync now ]  [ Disconnect ]
  Reading: sleep, heart rate, HRV, resting HR

  (when error)  ⚠ Health Connect not installed
                [ Install from Play Store ]
```

Toggle starts off. Tap → rationale sheet → system permission dialog → poll status. Disconnect = deeplink to Health Connect settings (`ACTION_HEALTH_CONNECT_SETTINGS`).

### Week-2 nudge

**Trigger:** user has been in protocol ≥ 7 days (i.e., has entered week 2 or later — `currentWeek >= 2`, where week 1 begins at `program_started_at`) AND `nudgeShownAt IS NULL` AND `healthConnectStatus != granted`.

Computed against `cbti_weeks` table (program week index, not calendar week).

**Surface:** one-time banner above diary card on home screen.

```
┌─────────────────────────────────────┐
│ Curious how your sleep tracker      │
│ lines up with your diary?           │
│ [ Connect Health Connect ] [ Not now ] │
└─────────────────────────────────────┘
```

Dismiss either button → write `nudgeShownAt` to `shared_preferences`. Never shown again. Settings toggle remains the path forever after.

### Routing

New `go_router` route:
- `/diary/:date/sleep-record` → `SleepRecordDetailScreen`

Settings stays single-screen; HC section is inline.

## Permission flow

```
User taps "Connect"
  ↓
Rationale sheet (custom, ours)
  • What we read (5 items, plain language)
  • Where data goes ("stays on this device")
  • [ Continue ] [ Cancel ]
  ↓
HealthConnectPlugin.requestAuthorization([5 read scopes])
  ↓
System dialog (HC owns)
  ↓
On result:
  granted     → trigger sync, update status
  denied      → toggle reverts, no error UI
  partial     → use what we got, show "Limited" badge in settings
```

Rationale sheet required by Health Connect dev policy — system dialog appears second. Skipping rationale = Play Store rejection.

## Android manifest additions

`android/app/src/main/AndroidManifest.xml`:

```xml
<uses-permission android:name="android.permission.health.READ_SLEEP" />
<uses-permission android:name="android.permission.health.READ_HEART_RATE" />
<uses-permission android:name="android.permission.health.READ_HEART_RATE_VARIABILITY" />
<uses-permission android:name="android.permission.health.READ_RESTING_HEART_RATE" />

<queries>
  <package android:name="com.google.android.apps.healthdata" />
</queries>

<activity-alias
  android:name="ViewPermissionUsageActivity"
  android:exported="true"
  android:targetActivity=".MainActivity"
  android:permission="android.permission.START_VIEW_PERMISSION_USAGE">
  <intent-filter>
    <action android:name="android.intent.action.VIEW_PERMISSION_USAGE" />
    <category android:name="android.intent.category.HEALTH_PERMISSIONS" />
  </intent-filter>
</activity-alias>
```

`activity-alias` is mandatory for Health Connect — directs the system "why does this app want my health data" page back into noctos.

## Error & edge cases

| Condition | Behavior |
|---|---|
| HC app not installed | Settings shows "Install from Play Store" CTA → deeplink to `market://details?id=com.google.android.apps.healthdata`. Strip stays hidden. |
| HC installed but disabled | Same as not-installed (SDK returns `NotInstalled`). |
| Permission denied | Toggle reverts off. No retry prompt. User must re-tap toggle. |
| Permission partially granted | Use whatever subset granted. Settings shows "Limited" chip listing missing types. |
| Sync throws (network, IPC) | Silent fail. Log to local file via existing log infra. Settings shows "Last sync failed" + "Retry" button. Strip falls back to last cached record. |
| Future-dated sample (clock skew) | Clamp `sessionEnd` to `now()`. Log warning. |
| Multiple sessions same night (nap + main) | Display longest session as primary, expose all in detail screen under "All sessions today". |
| Session missing stages | Detail screen hides stage band, shows timing + HR only. |
| Session missing HR (no continuous tracking) | HR row hidden in detail. |
| Duplicate session from two sources (phone + watch) | Dedup by `sessionStart` rounded to nearest minute, prefer source with stages. |
| Permission revoked mid-use | Status stream emits `denied`, strip disappears next rebuild, settings flips toggle off. |
| User uninstalls HC | Same as revoked. |
| Clock changed (DST, manual) | Sessions stored UTC, displayed in local zone via existing `time_helpers`. |
| App backgrounded mid-sync | Sync is single-shot read; abandon, retry on next foreground. |

## Ethics page — `docs/health-integration.md`

To be written as part of implementation. Content:

```
# Health Connect integration

## What we read
- Sleep sessions (start, end, stages)
- Heart rate samples during sleep
- HRV (RMSSD) samples during sleep
- Resting heart rate

## Where it goes
Local SQLite, same database as your diary. Never leaves device.
noctos has no servers, no telemetry, no analytics.

## Why diary, not watch, drives the program
CBT-I sleep-restriction titration is calibrated on self-reported
sleep diaries (Spielman et al., 1987; Edinger & Carney, 2014).
Actigraphy systematically overestimates sleep — wrist sensors
cannot distinguish quiet wakefulness from sleep. Treatment
fidelity requires diary data.

Watch data displayed alongside for your own reference.

## Disconnecting
Settings → Health Connect → Disconnect. Deeplinks to Health
Connect's own permission management. Revoking removes our
access; existing local records remain unless you also wipe
app data.
```

Linked from Settings → Health Connect section ("Learn more").

## Testing

### Unit (`test/services/health/`)
- `sleep_record_sync_test.dart` — dedup by sessionStart, partial-data handling, future-timestamp clamping, multi-session-per-night selection
- `sleep_record_repository_test.dart` — upsertByNaturalKey, range queries
- `models_test.dart` — `SleepRecord.fromHealth` parsing of HC stage values

### Widget (`test/features/diary/`, `test/features/settings/`)
- `sleep_record_strip_test.dart` — three states (record / no record / not connected)
- `sleep_record_detail_screen_test.dart` — golden-style: with stages, without stages, without HR
- `health_connect_section_test.dart` — toggle states (off / connecting / granted / partial / error)

### Integration (`integration_test/`)
- Mock `HealthConnectService` via Riverpod override
- Verify: connect flow end-to-end, week-2 nudge fires once and only once, strip appears under correct diary entry

### Manual checklist (executed at release)
- Pixel 8 with Mi Band 7 + Mi Fitness
- Samsung Galaxy S24 with Galaxy Watch + Samsung Health
- HC uninstall mid-session
- Permission revoke from HC app
- Airplane mode (HC works offline, verify)

## Touch list — existing files

| File | Change |
|---|---|
| `pubspec.yaml` | add `health: ^11.x` |
| `lib/data/db/database.dart` | register `SleepRecords`, schema 3→4, migration |
| `lib/features/diary/home_screen.dart` | insert `SleepRecordStrip` + week-2 nudge banner |
| `lib/features/diary/diary_history_screen.dart` | insert `SleepRecordStrip` per row |
| `lib/features/settings/settings_screen.dart` | insert `HealthConnectSection` |
| `lib/core/router/router.dart` | add `/diary/:date/sleep-record` route |
| `android/app/src/main/AndroidManifest.xml` | 4 permissions, queries, activity-alias |
| `android/app/build.gradle.kts` | minSdk check (HC needs 26+, already met) |
| `README.md` | one paragraph under features mentioning HC |

## Timeline estimate

| Week | Work |
|---|---|
| 1 | Drift table + migration + repo + `health` package wiring + service skeleton + permission flow + Settings section |
| 2 | Sync orchestrator + dedup + diary strip + detail screen + week-2 nudge |
| 3 | Test suite (unit + widget + integration) + ethics doc + README + manifest hardening + manual device QA + bug fixes |

Three weeks one developer. Stretches to 4 if Health Connect SDK surprises.
