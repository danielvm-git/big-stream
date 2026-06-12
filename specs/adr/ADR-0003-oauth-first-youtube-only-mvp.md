# ADR-0003: OAuth-first destinations, YouTube-only MVP

Date: 2026-06-12 · Status: accepted

## Context
The product wedge is "any idiot can stream"; pasting stream keys (the OBS experience) is disqualified. The YouTube Live Streaming API can create the broadcast, fetch ingest credentials invisibly, transition live, and publish the VOD. Each extra destination adds OAuth review, API quirks, and reconnect logic (~3-4 weeks each).

## Decision
YouTube via OAuth (PKCE — the client secret ships in a desktop binary and is treated as public) is the only first-class MVP destination. A custom RTMP URL field is the power-user escape hatch. Twitch and simultaneous multistream are post-1.0. Google OAuth verification is started around 0.4.0 so approval lands before 0.6.0 needs it.

## Consequences
- No automated tests against live YouTube (quota/ban risk): URLProtocol stubs + a manual pre-release smoke checklist against an unlisted broadcast.
