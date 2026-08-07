# Homelab AI Stack

> **Status: pre-1.0, work in progress.** The structure is real and readable, but **no block has been validated against real hardware yet** — all three currently ship marked `unverified`. Nothing here is a finished, tested product. Open gaps are tracked as a running list in [`docs/roadmap.md`](docs/roadmap.md), including what `1.0` would actually require.
>
> **This affects real infrastructure.** Read [`DISCLAIMER.md`](DISCLAIMER.md) before following any block — it covers what these templates can't fully protect you from (data loss, downtime, hardware misconfiguration) and why the safety cadence lowers that risk without removing it.

AI-agent instruction templates that guide someone from "found this repo, own nothing yet" through choosing what to build, picking hardware and an AI tool, and safely operating a real homelab afterward — with an AI agent doing the guiding at every step.

This is not a runnable docker-compose stack and not a curated link list. It's the layer that helps an AI agent reason about *your* homelab specifically, instead of generically. See [`docs/index.md`](docs/index.md) for why that distinction matters.

## Start here

**Hand your AI agent [`start-here/TRAVERSAL.md`](start-here/TRAVERSAL.md).** That's the whole first step — it tells the agent how to read your current state, work out what's already decided, resolve what has to happen before what, and open the right file next. A fresh session picks up where the last one stopped instead of re-interviewing you.

If you'd rather see the path yourself first, it runs through [`discovery/`](discovery/):

1. [`discovery/needs.md`](discovery/needs.md) — what you actually want to run, and how comfortable you are getting there.
2. [`discovery/ai-tooling.md`](discovery/ai-tooling.md) — what kind of AI tool you need to keep using these templates.
3. [`discovery/hardware-envelope.md`](discovery/hardware-envelope.md) — turns what you want into a hardware spec, not a shopping list.

From there: the **foundation** tier decides what runs on the bare metal and how it's networked — [`blocks/foundation/host-platform/`](blocks/foundation/host-platform/) and [`blocks/foundation/network/`](blocks/foundation/network/) — then a **domain** block like [`blocks/domains/proxmox-ai-stack/`](blocks/domains/proxmox-ai-stack/) builds on top of both.

Letting your agent guide the conversation is the intended way to use this repo — not reading it top to bottom yourself first. `start-here/TRAVERSAL.md` is what makes that work; handing over an individual file below also works if you already know where you are.

## How it's organized

Every template here — a **block** — ships as a **Checklist + Example + Placeholders** triple (the **CEP method**), never generic prose with blanks. See [`docs/block-schema.md`](docs/block-schema.md) for the exact shape, and [`docs/methodology.md`](docs/methodology.md) for the two cadences that govern how an agent behaves: one for guiding decisions, one for executing changes against real infrastructure.

Blocks declare what they depend on (`requires:`), so choices compose instead of contradicting each other — wanting both a media server and an AI stack changes the hardware envelope for both, and that only works if each block states its prerequisites honestly.

As you go, an agent maintains two files in *your own* repo, next to your own `AGENTS.md` — `.homelab-state.yml` (machine-readable progress) and `HOMELAB.md` (a plain-language log of what was decided and why). See [`docs/manifest-schema.md`](docs/manifest-schema.md).

```
start-here/                       — hand TRAVERSAL.md to your agent; it routes everything below
discovery/                        — the first stop, if nothing is set up yet
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

All three blocks — both foundation blocks and the flagship domain block — currently ship **unverified**. The structure, checklists, and cadences are deliberate, but none has been dogfooded end-to-end against real hardware yet, and each says so in its own `README.md` and in its `AGENTS.md.example` frontmatter. This repo would rather label that honestly than imply a test that hasn't happened.

Concretely, that means: trust the shape and the safety cadence, treat the exact commands as a starting point to check against current official docs. See [`docs/methodology.md`](docs/methodology.md) for how validation works and [`docs/roadmap.md`](docs/roadmap.md) for what's needed to close this out.

## What's next

Closing the gaps in [`docs/roadmap.md`](docs/roadmap.md) — first among them dogfooding the flagship block against real Proxmox hardware, which is what moves this past `0.x`.

After that: media, home automation, and personal-cloud/backup blocks, following the same block schema — see [`CONTRIBUTING.md`](CONTRIBUTING.md) if you want to add one. They're intentionally not scaffolded yet, so the repo stays one real path deep instead of a folder of stubs.

## Contributing

See [`CONTRIBUTING.md`](CONTRIBUTING.md) for the Definition of Done and the link-vetting rule (official/vendor sources only — no third-party reimplementations).

## License

[MIT](LICENSE)
