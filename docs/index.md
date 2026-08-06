# Why this repo works the way it does

Most homelab content on the internet is one of two things: a fixed tutorial ("install Proxmox, then run these commands") or a buyer's guide that's stale within months. Neither survives contact with an AI agent well. A tutorial doesn't adapt to your hardware. A buyer's guide can't tell an agent what to do with your GPU.

This repo is neither. It's a set of instruction templates an AI agent can actually use to guide someone from zero to a running homelab, and then to keep operating it safely afterward.

## Why generic instructions don't work

Good agent context files (`AGENTS.md`, `CLAUDE.md`, and similar) work because they're short, specific, and describe one real environment. A file that says "describe your Proxmox cluster here" is not a shortcut — it's an empty form. It doesn't tell an agent what your node is called, where your GPU lives, or what it should never touch. So every template here — called a **block** — ships as three parts instead of one prose file:

- A **checklist** of exactly what an agent needs to know.
- A **filled example** showing what a good answer looks like, with fake-but-realistic values.
- A **placeholder convention** so it's unambiguous what to swap.

We call this the CEP method (Checklist / Example / Placeholders). See `block-schema.md` for the literal structure.

## Why hardware and tool advice aren't picks

"Best Mini PC 2026" articles are obsolete by the time you read them, and this repo isn't trying to compete with them. Instead, discovery content asks what *determines* a good answer — target workloads, transcoding needs, VRAM for local models, budget — and produces a **spec envelope**, not a shopping list. Where a specific product or tool is genuinely useful to name, it's marked explicitly as an illustration, isolated in one small file that's cheap to keep current, never baked into the instructions an agent actually executes.

## Why the journey starts at discovery, not at a technical block

Most homelab guides assume you already know you want Proxmox, or Docker, or a particular stack. This repo assumes you might have nothing yet — not even the AI tool to guide you. So it starts at `discovery/`: what do you actually want to run, what hardware class do you need, what kind of AI tool fits the job. Everything downstream — host platform, then domain blocks like the AI stack — builds on that, declared explicitly through each block's `requires:` field so choices compose instead of contradicting each other.

## Why there's no owned reference environment

This repo doesn't maintain a docker-compose stack or an infrastructure fixture of its own — that was a deliberate fork, and the tradeoff it carries (no mechanical re-validation, so first-party blocks depend on live dogfooding) is tracked openly in [`roadmap.md`](roadmap.md). Blocks link out to official, vendor-maintained sources for anything runnable. That keeps this repo's job narrow: be the layer that helps an agent guide you and operate safely, not another piece of infrastructure to keep alive.
