# Homelab AI Stack

> **Status: pre-1.0, work in progress.** The structure is real and readable, but **no block has been validated against real hardware yet** — both currently ship marked `unverified`. Nothing here is a finished, tested product. Open gaps are tracked as a running list in [`docs/roadmap.md`](docs/roadmap.md), including what `1.0` would actually require.
>
> **This affects real infrastructure.** Read [`DISCLAIMER.md`](DISCLAIMER.md) before following any block — it covers what these templates can't fully protect you from (data loss, downtime, hardware misconfiguration) and why the safety cadence lowers that risk without removing it.

AI-agent instruction templates that guide someone from "found this repo, own nothing yet" through choosing what to build, picking hardware and an AI tool, and safely operating a real homelab afterward — with an AI agent doing the guiding at every step.

This is not a runnable docker-compose stack and not a curated link list. It's the layer that helps an AI agent reason about *your* homelab specifically, instead of generically. See [`docs/index.md`](docs/index.md) for why that distinction matters.

## Start here

If you have nothing set up yet — no hardware decided, maybe not even an AI tool — start at [`discovery/`](discovery/):

1. [`discovery/needs.md`](discovery/needs.md) — what you actually want to run, and how comfortable you are getting there.
2. [`discovery/ai-tooling.md`](discovery/ai-tooling.md) — what kind of AI tool you need to keep using these templates.
3. [`discovery/hardware-envelope.md`](discovery/hardware-envelope.md) — turns what you want into a hardware spec, not a shopping list.

From there: the **foundation** tier decides what runs on the bare metal and how it's networked — [`blocks/foundation/host-platform/`](blocks/foundation/host-platform/) and [`blocks/foundation/network/`](blocks/foundation/network/) — then a **domain** block like [`blocks/domains/proxmox-ai-stack/`](blocks/domains/proxmox-ai-stack/) builds on top of both.

Hand any of these files to your AI agent and let it guide the conversation — that's the intended way to use this repo, not reading it top to bottom yourself first.

## How it's organized

Every template here — a **block** — ships as a **Checklist + Example + Placeholders** triple (the **CEP method**), never generic prose with blanks. See [`docs/block-schema.md`](docs/block-schema.md) for the exact shape, and [`docs/methodology.md`](docs/methodology.md) for the two cadences that govern how an agent behaves: one for guiding decisions, one for executing changes against real infrastructure.

Blocks declare what they depend on (`requires:`), so choices compose instead of contradicting each other — wanting both a media server and an AI stack changes the hardware envelope for both, and that only works if each block states its prerequisites honestly.

As you go, an agent maintains two files in *your own* repo, next to your own `AGENTS.md` — `.homelab-state.yml` (machine-readable progress) and `HOMELAB.md` (a plain-language log of what was decided and why). See [`docs/manifest-schema.md`](docs/manifest-schema.md).

```
discovery/                        — start here if nothing is set up yet
blocks/
  foundation/                     — decisions nearly everything else depends on
    host-platform/                — isolation-, storage-, simplicity-, or raw-control-first
    network/                      — topology, addressing, the VLAN/bridge question domain blocks used to ask themselves
  domains/                        — the end-user-facing workloads
    proxmox-ai-stack/             — Proxmox + GPU passthrough + local AI stack (flagship block)
  (core-services/ — named, not yet built: reverse proxy, DNS, auth — see docs/block-schema.md)
docs/                             — methodology, block schema, manifest schema, philosophy
```

## Verification status

Both blocks currently ship **unverified** — the structure, checklists, and cadences are deliberate, but neither has been dogfooded end-to-end against real hardware yet, and each says so in its own `README.md` and in its `AGENTS.md.example` frontmatter. This repo would rather label that honestly than imply a test that hasn't happened.

Concretely, that means: trust the shape and the safety cadence, treat the exact commands as a starting point to check against current official docs. See [`docs/methodology.md`](docs/methodology.md) for how validation works and [`docs/roadmap.md`](docs/roadmap.md) for what's needed to close this out.

## What's next

Closing the gaps in [`docs/roadmap.md`](docs/roadmap.md) — first among them dogfooding the flagship block against real Proxmox hardware, which is what moves this past `0.x`.

After that: media, home automation, and personal-cloud/backup blocks, following the same block schema — see [`CONTRIBUTING.md`](CONTRIBUTING.md) if you want to add one. They're intentionally not scaffolded yet, so the repo stays one real path deep instead of a folder of stubs.

## Contributing

See [`CONTRIBUTING.md`](CONTRIBUTING.md) for the Definition of Done and the link-vetting rule (official/vendor sources only — no third-party reimplementations).

## License

[MIT](LICENSE)
