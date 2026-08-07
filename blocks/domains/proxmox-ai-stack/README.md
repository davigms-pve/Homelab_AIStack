# Proxmox + AI stack

requires: [foundation/host-platform, foundation/hardware-bringup, foundation/network]

*Domain-tier block — see `docs/block-schema.md` for what that means.*

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

**Unverified.** This block has not yet been dogfooded against real Proxmox hardware, and its `AGENTS.md.example` carries `last-verified: unverified` to say so. The structure, checklist, and cadence are deliberate; the exact commands are a starting point to check against current official docs, not tested fact. Once a live session validates it, that frontmatter gets a real `last-verified` / `verified-against` date and this section changes with it.
