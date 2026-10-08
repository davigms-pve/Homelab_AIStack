# Traversal — how an agent works out what to do next

**You are an AI agent and someone handed you this repo.** This file tells you where you are, what has to happen before what, and which block to open next. It does not tell you *how to behave* — that's `../docs/methodology.md`, which owns both cadences. Read this to navigate; read that to act.

Everything below is about position in the dependency graph. Nothing below authorizes touching infrastructure.

## Before anything else

Confirm the standing methodology agreement — step 0 of the Agent Operating Cadence in [`../docs/methodology.md`](../docs/methodology.md). That gate holds regardless of what this file says and regardless of whether your harness auto-approves actions. Do not skip it to get to the interesting part.

## Step 1 — read state

Look for `.homelab-state.yml` in the user's own repo (not this one — see [`../docs/manifest-schema.md`](../docs/manifest-schema.md)). **If you have no file access, ask the person to paste `.homelab-state.yml` and `HOMELAB.md`** (or tell you they don't exist yet); the Discovery & Advisory Cadence, step 6, says how persistence works when they are the file system.

- **It doesn't exist — or there's no "user's own repo" yet at all.** That's the normal first-time case: someone who owns nothing yet has nowhere for these files to live. Don't hunt for it, and don't write into *this* repo. Ask once where the two files should go, offer a default so the question is answerable in three words (a new folder in their home directory is fine), and move on. This is housekeeping and must never become a blocker. Then go to [`../discovery/needs.md`](../discovery/needs.md) and follow the Discovery & Advisory Cadence, creating both files at the first confirmed decision rather than at the end.
- **It exists** → read it fully before proposing anything, including `HOMELAB.md` for the *why* behind past decisions. If `blocks:` shows anything at `awaiting-human`, read the `awaiting:` record — its `agent-resumes-by` field is your first action, and it exists so you don't re-interview anyone. Continue to step 2.

## Step 2 — resolve `requires:`

Every block and discovery topic declares `requires:` near the top of its file. Resolving it means answering: *has each prerequisite already been satisfied?* The declarations come in four shapes, and they resolve differently.

| Shape | Example | Where it appears | How to resolve it |
|---|---|---|---|
| Tiered path | `requires: [foundation/host-platform, foundation/network]` | domain block `README.md` | **Take the last path segment** — `foundation/host-platform` → `host-platform` — and look that up as a key under `blocks:` in `.homelab-state.yml`. Satisfied when its status is `done`. |
| Folder name | `requires: [discovery]` | foundation block `README.md` | Already flat. Look up `discovery` under `blocks:` directly. Satisfied when `done`. |
| Discovery topic | `requires: [needs]` | files inside `discovery/` | **There is no `blocks:` entry for individual topics** — `blocks: discovery` is deliberately one key for all three (see `manifest-schema.md`). Resolve by checking whether the keys that topic *produces* are present under `decisions:`. See the table below. |
| None | `requires: none` | [`../discovery/needs.md`](../discovery/needs.md) | The root of the graph. Nothing precedes it. |

### `excluded` can satisfy a requirement — but verify the fact, not the status

A prerequisite is satisfied when its status is `done`. It is **also** satisfied when the status is `excluded`, because `excluded` means the person deliberately opted out — and for some blocks that's because the block's output is already true by other means. Someone who already owns a running server marks `hardware-bringup: excluded`; there's nothing to build, and blocking every domain block forever would be absurd.

**Don't trust the status blindly.** Where `excluded` satisfies a requirement, confirm the thing it stands for actually exists before proceeding — for `hardware-bringup` that means `decisions.host_access` is present and the host genuinely answers. An `excluded` status with no working host behind it is someone who skipped a step, not someone who didn't need it.

**`agent-operations: excluded` is the one case where the underlying fact isn't infrastructure.** Excluding it is legitimate for someone who already operates under their own conventions — an experienced person with an established `AGENTS.md` and their own way of tracking findings doesn't need this repo's version imposed on top. It is **not** legitimate as "skip the one that isn't building anything," because everything downstream assumes *some* operating contract exists: the state file will be written by many sessions, and nothing else in this repo governs how it stays true.

So before accepting it: confirm either `decisions.operations` is recorded, or `HOMELAB.md` says plainly that the person operates under their own conventions instead. If neither is there, this wasn't a decision — say so and offer the two-question version, which takes one exchange.

This is separate from the rule below about never *proposing* an excluded block. Satisfying a dependency and being offered as the next thing to work on are different questions.

The tiered-path and flat-key forms are deliberately different shapes — `requires:` navigates this repo, `blocks:` just tracks status. The last-path-segment rule is the whole bridge between them; block names are unique across tiers, so it can't collide.

### Resolving discovery topics by their outputs

| Topic | Satisfied when `decisions:` contains |
|---|---|
| `needs` | `wants`, `priority`, `comfort_level`, `budget_band`, `constraints` |
| `hardware-envelope` | `hardware_envelope` |
| `ai-tooling` | `agent_capability` (`shell-capable` or `advisory-only`) |

`blocks: discovery` flips to `done` only when all three topics are satisfied.

**Don't self-certify `agent_capability` and move on.** You know your own capability class, so that half is free — but `discovery/ai-tooling.md` also asks where the tool runs and what it costs, and those are the person's answers. Confirm the class with them, then record it.

**If `agent_capability` is `advisory-only`, stop at the end of discovery.** Every discovery topic can be completed by an advisory-only assistant, with the person saving the state files by hand; nothing past it can. Say so plainly rather than starting a foundation block you can't finish — and because the value is recorded, a later session with an execution-capable agent knows exactly why things stopped instead of re-deriving it.

## Step 3 — pick the next block

Walk in this order and stop at the first thing that isn't satisfied:

1. **Discovery**, if `blocks: discovery` isn't `done`. Work the topics in dependency order: `needs` first, then `hardware-envelope` and `ai-tooling` (which both require `needs` but not each other).
2. **Foundation blocks, in this order** — [`agent-operations`](../blocks/foundation/agent-operations/) sets the contract for how the two tracking files are kept true, [`host-platform`](../blocks/foundation/host-platform/) decides what runs on the metal, [`hardware-bringup`](../blocks/foundation/hardware-bringup/) gets a machine built and reachable, [`network`](../blocks/foundation/network/) formalizes topology and addressing. The order matters: you can't build to a platform you haven't chosen, and `network` asks which physical NICs the host has, which nobody knows until it exists. All four must be satisfied before any domain block.

   **`agent-operations` goes first and takes one short conversation.** It looks like a day-2 concern parked at the front, and it is — deliberately. Its contract governs `.homelab-state.yml` and `HOMELAB.md`, which you started writing during discovery, and a contract adopted after those files have grown is a cleanup job instead of a contract. Two questions, then it's done.
3. **A domain block** whose `requires:` are now all satisfied, chosen by the user's `priority` field — not by what's most interesting to build.

Four rules that override the walk:

- **Never propose a block whose status is `excluded`.** That's a decision the person already made. If circumstances changed, ask before reopening it.
- **If a prerequisite is `in-progress`, finish it before starting anything downstream.** A half-decided host platform is worse input than an undecided one, because it looks settled.
- **If a prerequisite is `awaiting-human`, report position and stop. Do not try to finish it.** `awaiting-human` means the next move is physically theirs — parts haven't arrived, the machine isn't assembled, the OS isn't installed. Say where things stand, restate what they're waiting on from the `awaiting:` record, and offer to help with anything that doesn't depend on it. Treating this like `in-progress` and pushing forward is how an agent ends up inventing state it can't see.
- **If `priority` names a category with no block, say so plainly and don't substitute.** Not every category `discovery/needs.md` offers has a block yet. Tell them which of their wants this repo can and can't take them through, offer to work the covered ones, and point them at the block-gap issue template. Do **not** quietly promote their second choice and proceed as though it were their first — they'll discover the swap later and won't know what else was decided on their behalf.

### Once a block is `done`, the operating contract is live

`agent-operations` is the only foundation block whose output keeps applying after it closes. From the moment it's `done`, two of its rules bind every later session, including yours:

- **If `handoff:` in `.homelab-state.yml` is non-empty, draining it is your first task** — before the walk above resumes, not after the interesting work.
- **`next:` holds at most three items, and every open item carries a reference.** If you find it over the cap or an item without one, that's the contract already slipping; fix it as you pass through.

## Step 4 — check `assumes:` before entering the block

Blocks that need the person to *do* something declare an `assumes:` list next to `requires:` — `physical-assembly`, `os-install`, `bios-firmware`, `network-hardware`. See [`../docs/block-schema.md`](../docs/block-schema.md) for what each means and the fallback for each.

Compare that list against `decisions.comfort_level` and against anything `HOMELAB.md` records about what they're willing to do. **Where there's a mismatch, say it out loud before the work starts, with the fallback attached.** "This next part assumes you're comfortable opening a case and seating components. If you'd rather not, the spec we just wrote is exactly what a shop needs to build it for you — that path is fully supported and costs you nothing here."

Two rules about how this lands:

- **Announce at entry, never mid-block.** The entire value is that someone can decide, or go learn the thing, *before* they're committed. A capability discovered halfway through is the failure this field exists to prevent.
- **It's preparation, not permission.** Never use `assumes:` to tell someone they can't proceed. Read `comfort_level` as "how much explaining to do," not as a gate — and remember it's a self-reported general level, not a per-task one. Ask rather than infer: plenty of people who've never opened a terminal have built a PC.

## Step 5 — hand off to the right cadence

Once you know which block is next, [`../docs/methodology.md`](../docs/methodology.md) governs what happens inside it. Which of the two cadences applies is a property of the block, and each block's own `README.md` and `CHECKLIST.md` say which:

- `discovery/` and the foundation blocks are decision stages — Discovery & Advisory Cadence, with a thin edge of real execution in the foundation blocks once a choice is made.
- Domain blocks execute against real infrastructure — Agent Operating Cadence.

Say the transition out loud when it happens. "Discovery complete, moving to execution mode for the host-platform block" is the boundary, and the person should hear it.

## When a block's checklist can't be satisfied

If a checklist asks for something the person genuinely can't answer, that is not a reason to guess a value and continue. Offer the common-case default, name the tradeoff, record what was assumed in `HOMELAB.md`, and move on — per the Discovery & Advisory Cadence's rule that "I don't know" is valid input.

If a checklist is missing something your environment needed, that's a gap in this repo, not in the person. Point them at the block-gap issue template — see [`../CONTRIBUTING.md`](../CONTRIBUTING.md).
