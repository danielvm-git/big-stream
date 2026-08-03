# BigStream

BigStream is a macOS live-streaming studio app that lets a solo developer go live on YouTube and record locally in under 60 seconds — StreamYard-grade simplicity, zero servers, zero stream keys.

## Stack
- Swift 6 (strict concurrency)
- SwiftUI
- macOS 14+
- SwiftPM + XcodeGen
- HaishinKit 2.2.x (pinned)

## Features
- **One-Click Go Live**: Orchestrates YouTube Live Streaming API and RTMP engine.
- **Local Recording**: Simultaneous high-quality MP4 recording.
- **Zero Configuration**: No stream keys or complex settings required for standard use.

## Architecture

SwiftUI views observe a single `@Observable @MainActor AppState`, which injects actor services: `CaptureService` (ScreenCaptureKit screen/window + camera + mic), `Compositor` (Core Image/Metal: screen + camera bubble → composite CMSampleBuffers), `StreamEngine` (actor protocol wrapping HaishinKit MediaMixer/RTMPStream/StreamRecorder for RTMP publish + simultaneous local MP4), and `YouTubeService` (OAuth PKCE, broadcast lifecycle via YouTube Live Streaming API).

## Getting Started
1. Install [XcodeGen](https://github.com/yonaskolb/XcodeGen).
2. Run `xcodegen generate` to create the `.xcodeproj`.
3. Open `BigStream.xcodeproj`.

## How to use

```bash
xcodegen generate                                                          # generate .xcodeproj
xcodebuild -scheme BigStream -configuration Debug build && open build/Debug/BigStream.app   # run
swift test                                                                 # test (SwiftPM targets)
xcodebuild -scheme BigStream -configuration Release build                  # release build
swiftlint                                                                  # lint
```

## Tests

Media tests use golden-frame image comparison for the Compositor, MediaMTX as a local/CI RTMP sink, and ffprobe assertions on recordings (A/V PTS drift < 50ms). Live YouTube API calls are never automated in tests (quota/ban risk) — URLProtocol stubs are used instead, with a manual smoke checklist before release.

## Contribute

See [CLAUDE.md](CLAUDE.md) / [AGENTS.md](AGENTS.md) for full conventions, including the project's ubiquitous language and hard constraints (e.g. HaishinKit is only ever accessed through the `StreamEngine` actor protocol).

## License
MIT License - see [LICENSE](LICENSE) for details.
