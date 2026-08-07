# The tracking artifacts: `.homelab-state.yml` + `HOMELAB.md`

These two files don't live in this repo — they're what an agent creates and maintains in the **user's own** infra repo, sitting next to their own `AGENTS.md`. This page documents the schema so any agent following these templates writes them the same way.

## Why two files, not one

A person browsing their own homelab's progress shouldn't have to parse YAML. An agent reading state each session shouldn't have to parse prose. So the two audiences get separate files instead of one file trying to serve both — but they are always written **together, in the same operation**, by the agent only. Nothing else ever writes to either file, so they can't drift out of sync as long as that rule holds. Updating one without the other is a bug.

## `.homelab-state.yml` — machine state

Current snapshot only, overwritten as state changes:

```yaml
blocks:
  discovery: done
  host-platform: done
  network: done
  proxmox-ai-stack: in-progress
  media: excluded
  home-automation: planned

decisions:
  # recorded once, by Agent Operating Cadence step 0 — never re-asked once true
  methodology_agreed: true

  # from discovery/needs.md
  wants: [ai-stack, media]
  priority: ai-stack
  comfort_level: beginner-docker
  budget_band: under-1000
  constraints: [quiet, small-space]

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

  # from blocks/domains/proxmox-ai-stack/
  ai_vm_id: 105
```

Status values: `excluded`, `planned`, `in-progress`, `done`. The `blocks:` map uses short, flat, unique names — not the tiered folder paths (`blocks/foundation/host-platform/` etc.) that `requires:` uses elsewhere. It only needs to track status, and every block name is already unique across tiers, so there's nothing to gain from making it mirror the directory structure. See `docs/block-schema.md` for why `requires:` and `blocks:` are deliberately different shapes.

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

## When these get written

Per the Discovery & Advisory Cadence in `docs/methodology.md`: immediately at each confirmed decision, not batched at the end of a session. A session that ends mid-discovery should lose nothing.
