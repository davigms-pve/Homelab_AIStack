# Host platform

requires: [discovery]

*Foundation-tier block — see `docs/block-schema.md` for what that means.*

Before any domain block (AI stack, media, home automation) can be built, one foundational decision has to be made: what runs on the bare metal. This block turns discovery's output — desired workloads, the hardware envelope, comfort level — into that decision. It does not install anything by itself; it's the decision layer that domain blocks then build on.

## What this block produces

This isn't a single fork (hypervisor vs. not) — real homelab setups commonly optimize for one of several different priorities first, and the platform choice follows from that. Illustrative examples only, not a ranked list — check each project's own current docs before deciding, since specifics age faster than the criteria do:

- **Isolation-first** — multiple workloads that shouldn't share a kernel, or GPU passthrough dedicated to one VM. → Proxmox VE (this repo's flagship, most common in this space) or another Type-1 hypervisor.
- **Storage-first** — the priority is reliable, redundant storage (ZFS) with everything else built around it. → TrueNAS SCALE, or OpenMediaVault on lower-spec hardware. Note these aren't storage-only: both can also run containers and, to varying degrees, VMs — so this axis can overlap with isolation-first rather than exclude it.
- **Simplicity-first** — a single low-overhead machine running a handful of Docker apps behind a simple dashboard, minimal ops. → CasaOS or a similarly lightweight app-dashboard layer.
- **Raw-control-first** — comfortable scripting, wants nothing between them and the OS. → bare Debian/Ubuntu running Docker directly, no platform layer at all.

These axes aren't mutually exclusive silos — someone wanting both reliable storage and workload isolation needs a platform (or combination) that covers both, the same way `.homelab-state.yml`'s `wants` list already has to compose across domain blocks.

The decision, and why it was made, gets written to `.homelab-state.yml` / `HOMELAB.md` per `docs/manifest-schema.md` before any domain block starts.

## When to use this

**The first infrastructure decision**, after discovery and after `blocks/foundation/agent-operations/` has set the operating contract (one short conversation). This one chooses the platform; `blocks/foundation/hardware-bringup/` then gets a machine built and reachable, and `blocks/foundation/network/` formalizes addressing once there's a host to address. Every domain block declares all four foundation blocks in its `requires:`.

## Validation

**Rung L0 — written from official documentation, never checked against anything.** See the ladder in `docs/methodology.md`. Because this is a decision layer rather than an execution one, the risk of being wrong is lower than in a domain block — but the rung is the same, and "lower risk" is not evidence.

Worth naming: most of this block is criteria, and criteria can't be tested by running commands. What *can* be checked is whether each platform still fits the axis it's filed under, and whether its own project still recommends what this block says it does — which is an L1 desk-check, and the cheapest rung available to this block.
