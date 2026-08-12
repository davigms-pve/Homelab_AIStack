# Proxmox + AI stack

requires: [foundation/agent-operations, foundation/host-platform, foundation/hardware-bringup, foundation/network]
assumes: [physical-assembly, bios-firmware]

*Domain-tier block — see `docs/block-schema.md` for what that means.*

*`physical-assembly` because a card has to go into the machine; `bios-firmware` because IOMMU has to be enabled for passthrough. Fallbacks: a shop can install the card, and an agent can walk the firmware settings step by step. Worth saying out loud before starting — GPU passthrough is the most failure-prone thing in this repo, and on single-GPU hardware a wrong step can leave the machine without a usable console.*

This repo's first fully-realized domain block: Proxmox VM/LXC setup with GPU passthrough, running a local AI stack (LLM inference plus a chat interface) on top. It's the flagship example because it's heavier and more failure-prone than a docker-only setup — isolation, passthrough, and networking all have to work together — so it demonstrates the CEP method and the Agent Operating Cadence somewhere they actually get exercised.

## Scope

- Creating a VM (or LXC, where GPU passthrough allows it) on an already-installed Proxmox host (see `blocks/foundation/host-platform/` — this block assumes that decision is already made and recorded).
- Attaching that VM to the segment `blocks/foundation/network/` already decided — this block doesn't make its own networking decisions, only asks for the VM-specific address within whatever topology network/ produced.
- Passing a GPU through to that VM for local inference.
- Installing Docker inside the VM and deploying an LLM runtime plus a chat interface on top.
- What the agent must never touch: other VMs on the same node, storage pools already in use by other workloads, the Proxmox host's own network config beyond what this VM needs.

## What this block does not cover

Which specific LLM runtime or chat UI to run isn't fixed here — `AGENTS.md.example` uses commonly-paired official projects as the worked example, but the checklist and cadence apply regardless of which official project is chosen. Any software referenced is linked to its own official source, per the link-vetting rule in `CONTRIBUTING.md` — this repo doesn't bundle or fork any of it.

## Validation

**Rung L0 — written from official documentation, never checked against anything.** See the ladder in `docs/methodology.md`; the frontmatter on `AGENTS.md.example` says the same thing in machine-readable form. The structure, checklist, and cadence are deliberate; the exact commands are a starting point to check against current official docs, not tested fact.

This is the block with the furthest to climb and the most to gain from each rung, because it's the only one that both executes destructive changes and depends on hardware behavior that documentation routinely gets wrong. Two things are worth knowing about how it will climb: a nested-virtualization run can reach the Proxmox install, VM creation, and the container layer, but **structurally cannot** reach GPU passthrough, IOMMU grouping, or firmware settings — so an L3 here will carry a non-empty `unreached:` list until it runs on real metal. And `docs/roadmap.md` names the specific commands most likely to be wrong, so that L0 reads as a prediction rather than a shrug.
