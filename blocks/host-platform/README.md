# Host platform

requires: [discovery]

Before any domain block (AI stack, media, home automation) can be built, one foundational decision has to be made: what runs on the bare metal. This block turns discovery's output — desired workloads, the hardware envelope, comfort level — into that decision. It does not install anything by itself; it's the decision layer that domain blocks then build on.

## What this block produces

One of:
- **Bare OS** (e.g. Debian/Ubuntu running Docker directly) — simplest, least overhead, good fit for a single workload or a beginner comfort level.
- **Proxmox** (or another Type-1 hypervisor) — adds VM/LXC isolation, needed when running multiple workloads that shouldn't share a kernel, or when GPU passthrough to an isolated VM matters.
- **Other hypervisor** — covered by the same checklist; Proxmox is the flagship example because it's the most common in this space, not because it's assumed.

The decision, and why it was made, gets written to `.homelab-state.yml` / `HOMELAB.md` per `docs/manifest-schema.md` before any domain block starts.

## When to use this

Right after discovery, before touching any domain block. Every domain block in this repo declares `requires: [host-platform]` — this is the thing they all build on.

## Validation

**Unverified.** This block hasn't been walked end-to-end with a real person on real hardware yet, and its `AGENTS.md.example` carries `last-verified: unverified` to say so. Because it's a decision layer rather than an execution one, the risk is lower than in a domain block — but the honest status is the same.
