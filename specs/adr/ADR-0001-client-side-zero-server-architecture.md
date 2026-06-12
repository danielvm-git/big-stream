# ADR-0001: Client-side compositing, zero-server architecture

Date: 2026-06-12 · Status: accepted

## Context
StreamYard composites server-side because it serves multi-guest browser users and multistream fan-out. BigStream targets a solo streamer capturing their own Mac; browsers cannot speak RTMP, so a webapp would force per-broadcast cloud relay/encode infrastructure and its unit-economics burden. OBS source (C++/Qt desktop, libobs) was evaluated and rejected as a code basis: not portable to our stack, single-destination model; useful only as a conceptual reference for the scene/source/mixer data model.

## Decision
Native macOS app (Swift 6 + SwiftUI). Capture via ScreenCaptureKit, composite locally (Core Image/Metal), hardware encode via VideoToolbox, publish RTMP directly from the app. No servers; marginal cost per stream is zero.

## Consequences
- macOS-only initially; multistream costs user upload bandwidth (acceptable, v1.1+).
- A cloud restream relay can become a paid add-on later without rearchitecting.
