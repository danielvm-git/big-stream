# BigStream — Gemini CLI

Read CONVENTIONS.md before any GitHub or git operation.

## Project
BigStream is a macOS live-streaming studio app that lets a solo developer go live on YouTube and record locally in under 60 seconds — StreamYard-grade simplicity, zero servers, zero stream keys.
Stack: Swift 6 (strict concurrency) / SwiftUI / macOS 14+ / SwiftPM + XcodeGen / HaishinKit 2.2.x (pinned)

## Commands
| Action | Command |
|--------|---------|
| Generate project | `xcodegen generate` |
| Run    | `xcodebuild -scheme BigStream -configuration Debug build && open build/Debug/BigStream.app` |
| Test   | `swift test` (SwiftPM targets) / `xcodebuild test -scheme BigStream` |
| Build  | `xcodebuild -scheme BigStream -configuration Release build` |
| Lint   | `swiftlint` |

## Architecture
SwiftUI views observe a single `@Observable @MainActor AppState`, which injects actor services: `CaptureService` (ScreenCaptureKit screen/window + camera + mic), `Compositor` (Core Image/Metal: screen + camera bubble → composite CMSampleBuffers), `StreamEngine` (actor protocol wrapping HaishinKit MediaMixer/RTMPStream/StreamRecorder for RTMP publish + simultaneous local MP4), and `YouTubeService` (OAuth PKCE, broadcast lifecycle via YouTube Live Streaming API). All structured logging goes through `JSONLogger`. Telemetry is local-only.

## Ubiquitous language (use these names in types and specs)
- **Show** — a saved streaming setup (sources + destination + layout)
- **Session** — one live run of a Show (Go Live → End); produces one Recording and one VOD
- **Source** — Screen, Camera, Mic, SystemAudio
- **Composite** — the mixed frame stream produced by the Compositor
- **Destination** — YouTubeDestination or CustomRTMPDestination (the Recording is NOT a Destination)
- **Go Live / End** — the only user-facing verbs
- Banned: "broadcast" outside the YouTube adapter layer; "scene" anywhere.

## Conventions
- Swift 6 strict concurrency everywhere (`SWIFT_STRICT_CONCURRENCY: complete`); actors for services, `@MainActor` for UI state.
- `Sources/App` (entry + AppState), `Sources/Core` (services, actors), `Sources/UI` (SwiftUI views only); `Tests/BigStreamTests` using the Swift Testing framework (`@Suite`/`@Test`/`#expect`).
- Dependency injection through AppState init with fallback factories; in-memory fallbacks for tests.
- Conventional Commits enforced by hooks; semantic-release drives versions 0.1.0 → 1.0.0 per specs/release-plan.yaml.
- HaishinKit is accessed ONLY through the `StreamEngine` actor protocol — no HaishinKit imports outside `Core/StreamEngine/`.
- Media tests: golden-frame image comparison for the Compositor; MediaMTX as local/CI RTMP sink; ffprobe assertions on recordings (A/V PTS drift < 50ms).
- Drive PTS from CMSampleBuffer presentation time, never wall clock. Filter ScreenCaptureKit `.idle`/`.blank` status frames before appending.

## Never
- Never bump or unpin the HaishinKit version without an ADR.
- Never automate tests against the live YouTube API (quota/ban risk) — use URLProtocol stubs; manual smoke checklist before release.
- Never add server-side components or phone-home telemetry; the app is zero-server, local-only by design.
- Never add layout configurability, scenes, or multi-destination UI before 1.0.0 — one fixed layout is the product.
- Never commit OAuth tokens, stream keys, or recordings; never push directly to main (semantic-release owns it).
- Never enable App Sandbox (distribution is notarized DMG).

## Agent Rules
- **Workflow Mandate:** You MUST use the bigpowers skills (e.g. `plan-work`, `develop-tdd`, `orchestrate-project`) to perform tasks. DO NOT write code directly in response to a user prompt like "build this feature".
- Read specs/ before writing code.
- All planning and specifications MUST be written to `specs/` (`requirements/SCOPE_LATEST.yaml`, `release-plan.yaml`, `epics/`) before any code is generated.
- Write the minimum code that solves the stated problem. Nothing extra.
- Never refactor, rename, or reorganize code outside the task scope.
- Run tests after every change. Show evidence before declaring done.
- One clarifying question beats a wrong assumption baked into 200 lines.
