# Homelab AI Stack

> **Status: pre-1.0, work in progress.** The structure is real and readable, but **no block has been validated against real hardware yet** — every one currently sits at rung `L0` on the [verification ladder](docs/methodology.md), meaning written from official documentation and never checked against anything. Nothing here is a finished, tested product. Open gaps are tracked as a running list in [`docs/roadmap.md`](docs/roadmap.md), including what `1.0` would actually require.
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

From there the **foundation** tier runs in order: [`agent-operations/`](blocks/foundation/agent-operations/) sets how your two tracking files stay true over months, [`host-platform/`](blocks/foundation/host-platform/) decides what runs on the bare metal, [`hardware-bringup/`](blocks/foundation/hardware-bringup/) gets a real machine built and reachable, and [`network/`](blocks/foundation/network/) settles topology and addressing. A **domain** block like [`blocks/domains/proxmox-ai-stack/`](blocks/domains/proxmox-ai-stack/) builds on all four.

If you already own a running server, `hardware-bringup/` is the one you skip — mark it excluded and carry on. If you own a laptop and an idea, it's the one that matters most.

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
    agent-operations/             — the day-2 contract: how state stays true after the build is done
    host-platform/                — isolation-, storage-, simplicity-, or raw-control-first
    hardware-bringup/             — buy, build, install, get it reachable; the gap between deciding and having
    network/                      — topology, addressing, the VLAN/bridge question domain blocks used to ask themselves
  domains/                        — the end-user-facing workloads
    proxmox-ai-stack/             — Proxmox + GPU passthrough + local AI stack (flagship block)
  (core-services/ — named, not yet built: reverse proxy, DNS, auth — see docs/block-schema.md)
docs/                             — methodology, block schema, manifest schema, field evidence, philosophy
```

Two docs are worth knowing about by name: [`docs/methodology.md`](docs/methodology.md) holds both cadences and the verification ladder, and [`docs/field-evidence.md`](docs/field-evidence.md) records which of this repo's rules came from a real deployment rather than from research — and why that provenance doesn't count as verification.

## Verification status

Every block in this repo sits at **L0** — written from official documentation and reasoning, never checked against anything. Each says so in its own `README.md` and in its `AGENTS.md.example` frontmatter, and CI fails the build if those two ever disagree.

`L0` is the bottom of a five-rung ladder (`L0` researched → `L1` desk-checked → `L2` retro-validated against a running deployment → `L3` executed → `L4` reproduced by someone else), and **each rung above `L0` has to name an evidence artifact that exists** — a dated doc check, a divergence log, a run record, a dogfood report. The ladder replaced a single `unverified` flag because that flag said the same thing about content nobody had ever read against a vendor doc and content walked line by line against a real server. It also means progress here is visible: a block moving `L0` → `L1` is a real, checkable change, not a vibe.

Concretely, at `L0`: trust the shape and the safety cadence, treat every exact command as a starting point to check against current official docs. See [`docs/methodology.md`](docs/methodology.md) for the rungs and [`docs/roadmap.md`](docs/roadmap.md) for what's needed to climb them.

**Own hardware and want to help?** An `L4` — someone who didn't write these blocks following one on their own machine — is worth more to this repo than any amount of self-checking, because the author is the least-cold reader of this content on Earth. See the dogfood report template in [`.github/ISSUE_TEMPLATE/`](.github/ISSUE_TEMPLATE/).

## What's next

Closing the gaps in [`docs/roadmap.md`](docs/roadmap.md) — first among them dogfooding the flagship block against real Proxmox hardware, which is what moves this past `0.x`.

After that: media, home automation, and personal-cloud/backup blocks, following the same block schema — see [`CONTRIBUTING.md`](CONTRIBUTING.md) if you want to add one. They're intentionally not scaffolded yet, so the repo stays one real path deep instead of a folder of stubs.

## Contributing

See [`CONTRIBUTING.md`](CONTRIBUTING.md) for the Definition of Done and the link-vetting rule (official/vendor sources only — no third-party reimplementations).

## License

[MIT](LICENSE)
