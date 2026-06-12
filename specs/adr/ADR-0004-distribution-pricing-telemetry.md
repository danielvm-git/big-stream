# ADR-0004: Notarized DMG, free beta, macOS 14+, local-only telemetry

Date: 2026-06-12 · Status: accepted

## Context
ScreenCaptureKit + App Store would force full sandboxing and review delays; the developer's existing apps ship unsandboxed. macOS 14 provides SCContentSharingPicker (system window picker = low-friction UX) and modern @Observable. The audience (developers) is privacy-sensitive.

## Decision
- Distribution: direct-download notarized DMG (Developer ID), no App Sandbox. App Store reconsidered post-1.0 only.
- Pricing: 1.0 is a free beta; monetization (license/subscription) arrives with premium features (multistream) later. No payment infra in MVP.
- Minimum OS: macOS 14 Sonoma.
- Telemetry: stream-health events are local JSON logs only; the sole egress is a user-initiated "Export diagnostics" button. No crash reporter phoning home.

## Consequences
- Requires Apple Developer ID ($99/yr) and a notarization step in CI by 0.9.0.
- Field debugging relies on users exporting diagnostics voluntarily.
