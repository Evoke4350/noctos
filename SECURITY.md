# Security policy

## Supported versions

Only the latest `main` and most recent tagged release receive security fixes. noctos is pre-1.0 — there is no LTS branch.

## Reporting a vulnerability

**Do not file public issues for security bugs.**

Use GitHub private security advisories: repo → Security → Report a vulnerability. If that is unavailable, email the maintainer (address in commit history).

Include:

- Affected version / commit
- Reproduction steps
- Impact (data exposure, integrity, availability)
- Suggested fix if any

You will get an acknowledgement within 7 days and a triage status within 14 days. Coordinated disclosure preferred; we will credit reporters in release notes unless you ask otherwise.

## Scope

In scope:

- App code in this repository
- Build configs that could ship a backdoored binary
- Data-at-rest handling (Drift/SQLite, exports)
- Notification payload content

Out of scope:

- Bugs requiring a rooted device or attacker-controlled OS
- Social engineering of users
- Vulnerabilities in upstream dependencies (report those upstream; we will track and bump)
- "Missing TLS" — the app does not make network requests

## Threat model

noctos is local-first. It has no server, no account system, no telemetry. The realistic threats are:

1. Another app on the same device reading the SQLite DB.
2. Backups exfiltrating the DB.
3. A malicious supply-chain dependency.

Mitigations: Android `allowBackup=false` and `dataExtractionRules`; minimal dependency surface; Dependabot bumps.
