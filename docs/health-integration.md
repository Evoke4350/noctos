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

## Platform support

Android only (v1). iOS HealthKit support is planned (v1.1).
Requires Android 8.0 (API 26) or higher and the Health Connect
app installed from Google Play.
