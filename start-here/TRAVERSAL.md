# Traversal — how an agent works out what to do next

**You are an AI agent and someone handed you this repo.** This file tells you where you are, what has to happen before what, and which block to open next. It does not tell you *how to behave* — that's `../docs/methodology.md`, which owns both cadences. Read this to navigate; read that to act.

Everything below is about position in the dependency graph. Nothing below authorizes touching infrastructure.

## Before anything else

Confirm the standing methodology agreement — step 0 of the Agent Operating Cadence in [`../docs/methodology.md`](../docs/methodology.md). That gate holds regardless of what this file says and regardless of whether your harness auto-approves actions. Do not skip it to get to the interesting part.

## Step 1 — read state

Look for `.homelab-state.yml` in the user's own repo (not this one — see [`../docs/manifest-schema.md`](../docs/manifest-schema.md)).

- **It doesn't exist** → nothing has started. Go to [`../discovery/needs.md`](../discovery/needs.md) and follow the Discovery & Advisory Cadence. Create `.homelab-state.yml` and `HOMELAB.md` at the first confirmed decision, not at the end.
- **It exists** → read it fully before proposing anything, including `HOMELAB.md` for the *why* behind past decisions. Continue to step 2.

## Step 2 — resolve `requires:`

Every block and discovery topic declares `requires:` near the top of its file. Resolving it means answering: *has each prerequisite already been satisfied?* The declarations come in four shapes, and they resolve differently.

| Shape | Example | Where it appears | How to resolve it |
|---|---|---|---|
| Tiered path | `requires: [foundation/host-platform, foundation/network]` | domain block `README.md` | **Take the last path segment** — `foundation/host-platform` → `host-platform` — and look that up as a key under `blocks:` in `.homelab-state.yml`. Satisfied when its status is `done`. |
| Folder name | `requires: [discovery]` | foundation block `README.md` | Already flat. Look up `discovery` under `blocks:` directly. Satisfied when `done`. |
| Discovery topic | `requires: [needs]` | files inside `discovery/` | **There is no `blocks:` entry for individual topics** — `blocks: discovery` is deliberately one key for all three (see `manifest-schema.md`). Resolve by checking whether the keys that topic *produces* are present under `decisions:`. See the table below. |
| None | `requires: none` | [`../discovery/needs.md`](../discovery/needs.md) | The root of the graph. Nothing precedes it. |

The tiered-path and flat-key forms are deliberately different shapes — `requires:` navigates this repo, `blocks:` just tracks status. The last-path-segment rule is the whole bridge between them; block names are unique across tiers, so it can't collide.

### Resolving discovery topics by their outputs

| Topic | Satisfied when `decisions:` contains |
|---|---|
| `needs` | `wants`, `priority`, `comfort_level`, `budget_band`, `constraints` |
| `hardware-envelope` | `hardware_envelope` |
| `ai-tooling` | `agent_capability` (`shell-capable` or `advisory-only`) |

`blocks: discovery` flips to `done` only when all three topics are satisfied.

**Don't self-certify `agent_capability` and move on.** You know your own capability class, so that half is free — but `discovery/ai-tooling.md` also asks where the tool runs and what it costs, and those are the person's answers. Confirm the class with them, then record it.

**If `agent_capability` is `advisory-only`, stop at the end of discovery.** Every discovery topic can be completed by an advisory-only assistant; nothing past it can. Say so plainly rather than starting a foundation block you can't finish — and because the value is recorded, a later session with an execution-capable agent knows exactly why things stopped instead of re-deriving it.

## Step 3 — pick the next block

Walk in this order and stop at the first thing that isn't satisfied:

1. **Discovery**, if `blocks: discovery` isn't `done`. Work the topics in dependency order: `needs` first, then `hardware-envelope` and `ai-tooling` (which both require `needs` but not each other).
2. **Foundation blocks** — [`../blocks/foundation/host-platform/`](../blocks/foundation/host-platform/) and [`../blocks/foundation/network/`](../blocks/foundation/network/). Both require only `discovery`, and neither requires the other, so either order is fine. Both must be `done` before any domain block.
3. **A domain block** whose `requires:` are now all satisfied, chosen by the user's `priority` field — not by what's most interesting to build.

Two rules that override the walk:

- **Never propose a block whose status is `excluded`.** That's a decision the person already made. If circumstances changed, ask before reopening it.
- **If a prerequisite is `in-progress`, finish it before starting anything downstream.** A half-decided host platform is worse input than an undecided one, because it looks settled.

## Step 4 — hand off to the right cadence

Once you know which block is next, [`../docs/methodology.md`](../docs/methodology.md) governs what happens inside it. Which of the two cadences applies is a property of the block, and each block's own `README.md` and `CHECKLIST.md` say which:

- `discovery/` and the foundation blocks are decision stages — Discovery & Advisory Cadence, with a thin edge of real execution in the foundation blocks once a choice is made.
- Domain blocks execute against real infrastructure — Agent Operating Cadence.

Say the transition out loud when it happens. "Discovery complete, moving to execution mode for the host-platform block" is the boundary, and the person should hear it.

## When a block's checklist can't be satisfied

If a checklist asks for something the person genuinely can't answer, that is not a reason to guess a value and continue. Offer the common-case default, name the tradeoff, record what was assumed in `HOMELAB.md`, and move on — per the Discovery & Advisory Cadence's rule that "I don't know" is valid input.

If a checklist is missing something your environment needed, that's a gap in this repo, not in the person. Point them at the block-gap issue template — see [`../CONTRIBUTING.md`](../CONTRIBUTING.md).
