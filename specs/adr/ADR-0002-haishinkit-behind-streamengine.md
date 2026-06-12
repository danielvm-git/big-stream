# ADR-0002: HaishinKit 2.2.x (pinned) behind a StreamEngine actor protocol

Date: 2026-06-12 · Status: accepted

## Context
RTMP/FLV has no Apple framework; hand-rolling the protocol is months of non-differentiating work. Source review of HaishinKit 2.x: Swift 6 strict-concurrency native, actor-based (MediaMixer/RTMPStream/StreamRecorder), accepts externally composited CMSampleBuffers (pass-through mode), built-in RTMPS, reconnect (StreamSession), adaptive bitrate, multi-track audio mixing, and simultaneous local recording via a second mixer output. BSD-3 license. Risks: API churn between 2.x minors, sponsor-gated support, zero ScreenCaptureKit help, public-API typos.

## Decision
Adopt HaishinKit pinned to an exact 2.2.x tag. All access confined to `Core/StreamEngine/` behind our own `StreamEngine` actor protocol so it remains swappable. Capture, compositing, and timestamp hygiene stay in-house.

## Consequences
- Version bumps require an ADR update and full media-test pass.
- When stuck, read the cached source (`opensrc path HaishinKit/HaishinKit.swift`).
