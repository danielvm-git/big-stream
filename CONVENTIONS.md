# BigStream — Conventions for All Agents (Human and AI)

## Model & token strategy
- Frontier tokens are scarce. Route work by difficulty per `specs/plans/MODEL_STRATEGY.md` (free/DeepSeek for simple, Sonnet for hard Swift, Fable/Opus only for reviews and rescues). One story per session; `verify` commands judge correctness, not model opinion.

## Source of truth
- All planning output lives in `specs/`: `requirements/SCOPE_LATEST.yaml`, `release-plan.yaml`, `epics/eNN-*.yaml`, `adr/`, `bugs/`, `state.yaml`.
- Read `specs/state.yaml` at session start; update it when decisions are made or milestones reached.
- Architecture decisions get an ADR in `specs/adr/` before implementation.

## Git & releases
- Conventional Commits, enforced by commit hooks (commitlint + SwiftLint + tests via pre-commit).
- semantic-release owns versioning and tags: `feat:` → minor, `fix:` → patch, `BREAKING CHANGE:` → major. Roadmap: 0.1.0 → 1.0.0 per `specs/release-plan.yaml`.
- Feature branches + worktrees (`kickoff-branch`); never push directly to main; never force-push; never `reset --hard` shared history.
- PR titles follow Conventional Commits (squash merge).

## Code
- Swift 6, strict concurrency complete. Actors for services, `@Observable @MainActor` for UI state, Swift Testing framework for tests.
- Minimal dependencies. Current allowlist: HaishinKit (pinned 2.2.x), GRDB if persistence needs SQLite. Anything else needs an ADR.
- HaishinKit only behind the `StreamEngine` protocol in `Core/StreamEngine/`.
- Structured JSON logging via `JSONLogger` for every service event (stream health: dropped frames, reconnects, encode latency). Local-only; "Export diagnostics" is the only egress, user-initiated.
- Graceful degradation: fallback stores, corrupted-file backups (`.corrupted` suffix), no force unwraps outside tests.

## Defensive code categories (apply to this project)
- **Retry with backoff** — RTMP reconnect (via HaishinKit StreamSession, maxRetryCount), YouTube API calls, OAuth token refresh.
- **Timeout** — all network calls (RTMP handshake, Google APIs), capture-start, encoder warm-up.
- **Graceful degradation** — adaptive bitrate on poor uplink (StreamVideoAdaptiveBitRateStrategy); recording continues even if the RTMP publish drops; UI surfaces degraded state, never silently fails.
- **Circuit breaker** — repeated destination failures stop the publish attempt and tell the user, while the Recording keeps running.
- (Rate limiting is N/A client-side beyond respecting YouTube API quotas.)

## Media-pipeline rules
- PTS from CMSampleBuffer presentation time, never wall clock.
- Filter ScreenCaptureKit `.idle`/`.complete`/`.blank` frames before `append`.
- Mic = audio track 0; SystemAudio = track 1 (HaishinKit multiTrackAudioMixing).
- Tests: golden-frame comparisons (Compositor), MediaMTX container as RTMP sink (StreamEngine), ffprobe assertions (Recording: duration tolerance, A/V drift < 50ms). No automated tests against live YouTube.

## Streaming-the-development rule
- Any credentials shown on a recorded/streamed coding session are temporary keys, rotated immediately after the session.

## Never-do (hard stops)
- No server-side components. No phone-home telemetry. No App Sandbox.
- No layout/scene configurability before 1.0.0.
- No HaishinKit version changes without an ADR.
- No secrets, tokens, or recordings in git.
