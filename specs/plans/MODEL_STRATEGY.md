# Model & Token Strategy

Budget constraint: entry-level Claude plan (5h quota window), Antigravity, Cursor entry, OpenRouter, Nous portal, DeepSeek API. Frontier tokens are the scarcest resource — spend them on judgment, not typing.

## Principle
Planning already encoded the hard decisions (ADRs, epic shards, Gherkin + verify commands). Build work is therefore executable by cheap models, with tests as the quality gate. Quality comes from `verify` commands and hooks, never from model self-assessment.

## Routing table
| Work | Model/tool |
|---|---|
| Boilerplate, configs, YAML, docs, simple stories (e01, e10) | OpenCode Zen free (DeepSeek V4 Flash Free) or DeepSeek API |
| Standard SwiftUI, tests, medium stories (e02, e03, e05, e07, e09) | DeepSeek API or Antigravity Gemini 3.5 Flash (High) |
| Hard stories: Swift 6 concurrency, HaishinKit adapter, OAuth/PKCE, PTS (e04, e06, e08) | Claude **Sonnet 4.6** (not Fable/Opus) |
| Review gate before merge; rescuing stuck loops | Claude Fable/Opus — short, fresh sessions |
| Autocomplete / tiny edits | Cursor |
| Research questions | Nous portal / free tiers |

## Rules
1. Claude CLI default model for build sessions: Sonnet 4.6 or Haiku 4.5. Fable/Opus only for review checkpoints and rescues.
2. One story per session, fresh context. Agents bootstrap from CLAUDE.md + one epic shard — never paste the repo.
3. Never ask a model "does this work?" — run the story's `verify` command and paste failures back.
4. Escalation rule: if a cheap model fails the same compiler error (especially Sendable/strict-concurrency) twice, escalate to Claude Sonnet. Don't allow attempt #3.
5. Pre-commit hooks (e01) are the quality floor for all cheap-model output; e01 ships first for this reason.
6. Subagent tiering inside Claude Code: Haiku = mechanical tasks, Sonnet = medium implementation, Opus = heavy reasoning; orchestrator stays thin.

Expected split across the 68 stories: ~70% free/DeepSeek tiers, ~25% Claude Sonnet, ~5% Fable/Opus reviews.
