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

## Getting Started
1. Install [XcodeGen](https://github.com/yonaskolb/XcodeGen).
2. Run `xcodegen generate` to create the `.xcodeproj`.
3. Open `BigStream.xcodeproj`.

## License
MIT License - see [LICENSE](LICENSE) for details.
