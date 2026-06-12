# BigStream — Ubiquitous Language

| Term | Meaning |
|---|---|
| **Show** | A saved streaming setup: Sources + Destination + layout. Reused across sessions. |
| **Session** | One live run of a Show, from Go Live to End. Produces exactly one Recording and one VOD. |
| **Source** | A capture input: `Screen`, `Camera`, `Mic`, `SystemAudio`. |
| **Compositor** | Renders Sources into the Composite (one fixed layout: screen + camera bubble). |
| **Composite** | The single mixed video frame stream that is both published and recorded. |
| **Destination** | Where the Composite is published: `YouTubeDestination` (OAuth) or `CustomRTMPDestination`. The Recording is NOT a Destination — it is intrinsic to every Session. |
| **Recording** | The local MP4 of the Composite, written during every Session. |
| **StreamEngine** | The actor protocol owning encode + publish (wraps HaishinKit; only consumer of it). |
| **Go Live / End** | The only two user-facing verbs. |

## Banned terms
- **broadcast** — collides with YouTube API's `liveBroadcast`; allowed only inside the YouTube adapter layer.
- **scene** — OBS baggage; implies multi-layout, which is out of scope before 1.0.0.
