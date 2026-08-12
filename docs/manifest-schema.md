# The tracking artifacts: `.homelab-state.yml` + `HOMELAB.md`

These two files don't live in this repo — they're what an agent creates and maintains in the **user's own** infra repo, sitting next to their own `AGENTS.md`. This page documents the schema so any agent following these templates writes them the same way.

## Why two files, not one

A person browsing their own homelab's progress shouldn't have to parse YAML. An agent reading state each session shouldn't have to parse prose. So the two audiences get separate files instead of one file trying to serve both — but they are always written **together, in the same operation**, by the agent only. Nothing else ever writes to either file, so they can't drift out of sync as long as that rule holds. Updating one without the other is a bug.

## `.homelab-state.yml` — machine state

Current snapshot only, overwritten as state changes:

```yaml
blocks:
  discovery: done
  agent-operations: done
  host-platform: done
  hardware-bringup: done
  network: done
  proxmox-ai-stack: in-progress
  media: planned
  home-automation: excluded

next:
  - restore-test VM 105 from last night's backup   # 2026-08-04-untested-backups
  - pin the two AI-stack images by digest          # 2026-08-09-floating-tags

handoff:
  - open-webui answered slowly twice around 22:00, unclear if load or thermal

decisions:
  # recorded once, by Agent Operating Cadence step 0 — never re-asked once true
  methodology_agreed: true

  # from discovery/needs.md
  wants: [ai-stack, media]
  priority: ai-stack
  comfort_level: beginner
  budget_band: under-1000
  constraints: [quiet, small-space]

  # from discovery/ai-tooling.md — shell-capable or advisory-only
  agent_capability: shell-capable

  # from discovery/hardware-envelope.md
  hardware_envelope:
    cpu_cores: 6-8
    ram_gb: 32
    gpu: discrete-required
    vram_gb: 12
    drive_bays: 2
    idle_power_w: 35

  # from blocks/foundation/host-platform/
  host_platform: proxmox
  gpu_passthrough: true
  storage_layout: zfs-mirror

  # from blocks/foundation/hardware-bringup/
  host_access:
    method: ssh
    address: 192.0.2.50
    user: root
  machine_as_built:
    cpu_cores: 8
    ram_gb: 32
    drives: 2
    gpu_slot: free

  # from blocks/foundation/network/
  network_scheme: segmented-vlan
  vlans:
    - id: 10
      name: servers
      subnet: 192.0.2.0/24
    - id: 20
      name: iot
      subnet: 198.51.100.0/24
  bridge_mapping:
    vmbr0.10: servers

  # from blocks/foundation/agent-operations/
  operations:
    findings_tracker: homelab-md
    audit_cadence: monthly
    audit_last_run: 2026-08-01

  # from blocks/domains/proxmox-ai-stack/
  ai_vm_id: 105
```

### The contract that keeps this file a pointer

"Current snapshot only, overwritten as state changes" is an instruction, and instructions decay. In a real deployment operated this way, the equivalent file grew into a 984-line session journal that contradicted itself — the same work item listed as both done and open — and quietly swallowed findings that belonged in a tracker. A file that size cannot be kept consistent by an overwrite-each-session process, and no session ever decided to let it happen.

What holds is a **structural** contract, owned and enforced by [`blocks/foundation/agent-operations/`](../blocks/foundation/agent-operations/):

- **No narrative sections, ever.** If a sentence explains *why*, it belongs in `HOMELAB.md`. History belongs to that file and to git.
- **Every open item carries a reference** — an issue number, or a `HOMELAB.md` finding id in `date-slug` form.
- **`next:` holds at most three items.** More than three is a backlog, and a backlog belongs in the tracker.
- **`handoff:` is one-liners only**, parked by a session that ran out of time — and **draining it is the next session's first task**, before any new work. A handoff nobody drains is just a slower journal.

Structure rather than a line cap, for an asymmetric reason: forced compression fails by *silently deleting* a load-bearing fact and nobody learns which one, while bloat fails visibly and is repairable at the next maintenance pass. Structural rules also survive a weak session — they need shape-matching, not judgment about what to cut.

### Status values

`excluded`, `planned`, `in-progress`, `awaiting-human`, `done`.

**`awaiting-human` is the one that isn't obvious, and it exists because `in-progress` lies.** Some work can only be done by the person — buying parts, assembling a machine, installing an OS before anything is reachable over the network. During that stretch the agent isn't working; it's blocked, possibly for weeks. A block sitting at `in-progress` for a month tells the next session that work is underway, which is the opposite of true, and invites it to "pick up where things left off" when the honest answer is *it's your turn, not mine*.

When a block is `awaiting-human`, record what's being waited on:

```yaml
blocks:
  hardware-bringup: awaiting-human

awaiting:
  block: hardware-bringup
  checkpoint: parts-ordered
  since: 2026-08-06
  human-todo: see "Open work order" in HOMELAB.md
  agent-resumes-by: verifying delivered parts against decisions.hardware_envelope
```

`agent-resumes-by` is the field that earns its keep: it's what a fresh session reads to know its first action, without re-deriving anything or re-interviewing the person. Delete the `awaiting:` block when the status moves off `awaiting-human` — it describes a current wait, not history. The history belongs in `HOMELAB.md`.

### `wants` and `blocks:` describe the same intent, and must agree

`wants` is a **live** list, not a record of what was said once. If someone drops a category, it comes out of `wants` *and* its block goes to `excluded`, in the same write. If they add one, both move together.

This matters because blocks read it: `discovery/hardware-envelope.md` pulls "straight from the `wants` list" to size hardware. A stale `wants` sizes a machine for workloads nobody wants any more, and an over-eager `excluded` hides one they do. Concretely: **a block marked `excluded` must not appear in `wants`, and anything in `wants` must not be `excluded`.** Every other status is fair game — `planned` is exactly what a wanted-but-not-started block looks like.

The `blocks:` map uses short, flat, unique names — not the tiered folder paths (`blocks/foundation/host-platform/` etc.) that `requires:` uses elsewhere. It only needs to track status, and every block name is already unique across tiers, so there's nothing to gain from making it mirror the directory structure. See `docs/block-schema.md` for why `requires:` and `blocks:` are deliberately different shapes.

### Never record credentials

`host_access` says **how** to reach a host and as whom. It must never carry **what proves you may** — no passwords, SSH private keys, API tokens, or recovery codes, and no paths that amount to the same thing. This file gets committed, shared with agents, pasted into chats, and read by future sessions; a credential in it is a credential everywhere.

The same rule covers `HOMELAB.md`. Secrets live wherever the person already keeps secrets — an agent's job is to reference them, never to transcribe them.

### Every other file: redact by direction of travel

These two files are absolute. For everything else that ends up in a homelab repo — mirrored configs, compose files, unit files — the redaction question has one reliable test: **which way does this file flow?**

- **Live → repo** (the repo copy is a backup or mirror): redact before staging, grep the staged diff for key patterns, and **never copy the redacted mirror back over the live file** — that replaces a working config with placeholders.
- **Repo → live** (the repo copy is what deploys): **never redact**, because a placeholder would ship. Externalize the secrets into env or ignored files instead.

Getting this backwards is destructive in both directions, which is why every mirrored file should carry a provenance header naming its direction — no session should have to infer it. `blocks/foundation/agent-operations/` owns the full rule.

### `machine_as_built` is not `hardware_envelope`

`hardware_envelope` is what was aimed at, written during discovery. `machine_as_built` is what actually exists, written at `hardware-bringup` checkpoint 3 after a real connection confirmed it. Keep both: the gap between them is the useful part. A machine that came back with one drive fewer than planned is exactly the sort of thing later blocks need to notice rather than assume away.

### Closed vocabularies

Most `decisions:` values are free-form — a subnet is a subnet. Three are **closed sets**, because blocks branch on them, and free text turns a branch into a coin flip. Two agents writing `beginner-docker` and `novice` for the same person produce different downstream advice from the same facts.

**`comfort_level`** — exactly one of:

| Value | Means |
|---|---|
| `non-technical` | Hasn't used a terminal. Every step gets performed for them or explained in full. |
| `beginner` | Has followed guides, maybe run a container. Can type a given command; can't compose one. |
| `intermediate` | Comfortable in a terminal, runs containers routinely, can debug a simple failure. |
| `advanced` | Already operates servers. Comfortable with hypervisors, networking, and recovery. |

**`wants`** — any of `ai-stack`, `media`, `home-automation`, `personal-cloud`. These are the categories `discovery/needs.md` offers, and they match block names so `wants` and `blocks:` can be compared directly.

**`priority`** — exactly one value, which **must** also appear in `wants`.

Two things deliberately left open: `budget_band` is free-form because currency, region, and phrasing all vary (`under-1000`, `2000-3000`, `whatever-it-takes`) — nothing branches on it, it's read by a human or reasoned about in context. `constraints` is an open tag list for the same reason. If something later needs to branch on either, close it then and update this table — don't pre-emptively invent values nobody reads.

**Field names are set by the block that produces them,** and every block states which keys it writes. The list above is the union of what the blocks in this repo currently produce — a new block adds its own keys under `decisions:` and documents them in its own `CHECKLIST.md`. Nothing here is required to exist before the block that produces it has run; a mid-discovery state file is legitimately partial.

`blocks: discovery` is tracked as one entry even though `discovery/` holds three topics — it flips to `done` when all three have been worked through. Individual topics don't get their own status; they're too small to be independently resumable. An agent reads this file first, every session, as step 1 of the Agent Operating Cadence ("read current state") — this is what lets it pick up where things left off instead of re-interviewing.

**`methodology_agreed` is checked even earlier, at step 0**, before state is even read. It's the one field in this schema that isn't produced by a block — it's produced by the standing agreement described in `methodology.md`, obtained once and never silently skipped, regardless of whether the surrounding tool or harness auto-approves actions. `HOMELAB.md` gets a matching one-line log entry the first time it's recorded, the same way any other decision does.

## `HOMELAB.md` — human narrative

No YAML. A short "where things stand" summary at the top, then a dated, append-only log below it — never rewritten, only added to:

```markdown
# This homelab

Currently building: Proxmox + AI stack. Media and home automation are planned, not started.

## Log

### 2026-08-06
Chose Proxmox over bare Docker — wanted VM isolation between the media
stack (once it's added) and the AI stack. GPU passthrough confirmed
working on 01:00.0.
```

The log records *why*, not just *what* — that's the part the state file can't carry, and it's what makes this file worth reading months later instead of just useful to the agent in the moment.

Three rules keep it worth reading:

- **Entries for anything with real blast radius are written *before* the change, not after** — plan, why, expected result, rollback. The order is investigate → evidence → decision record → execute, because a record written afterwards drifts into justification for what already happened.
- **Entries are never silently edited.** Supersede a decision with a new dated entry, or amend it with a dated note. What was believed *when* has to stay legible, or the log stops being evidence and becomes a summary of the present.
- **Findings get a stable id** — `### 2026-08-04-ollama-cold-start` — so `.homelab-state.yml` can reference one from an open item without copying its contents. This is what makes the two-file split work for someone with no issue tracker, which is most people following this repo.

## When these get written

Per the Discovery & Advisory Cadence in `docs/methodology.md`: immediately at each confirmed decision, not batched at the end of a session. A session that ends mid-discovery should lose nothing.
