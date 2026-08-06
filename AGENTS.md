# AGENTS.md — working in this repo

This file governs an AI agent working **on this repository itself** (adding or editing blocks, docs, discovery content). It does not govern homelabs built from it — those instructions live in each block's own `AGENTS.md.example`, generated per user.

## What this repo is

A set of reusable AI-agent instruction templates that help an AI assistant guide someone from "found this repo, own nothing yet" through discovering what they want, choosing hardware and tooling, and operating real homelab infrastructure. It is not a runnable docker-compose product and not a curated link list — see `docs/index.md`.

## The one rule that matters most

Every template (a "block") ships as a **CEP triple**: a **C**hecklist of what an agent needs to know, a filled **E**xample using fake-but-realistic values, and the **P**laceholder convention for swapping them. A block missing any of the three is incomplete — see `docs/block-schema.md`. Generic prose with blanks is not useful to an agent; do not add one without the other two parts.

## Conventions

- Every folder that holds agent-oriented data (`CHECKLIST.md`, `AGENTS.md.example`) also holds a plain-language `README.md` as the human entry point. Don't add one without the other.
- Blocks declare a `requires:` list of prerequisite blocks. Never write a block that silently assumes a prior decision.
- Any link to a runnable stack must point at an official/vendor source (see `CONTRIBUTING.md`). Never link a third-party reimplementation.
- Discovery and hardware/tooling guidance state *criteria*, never brand rankings or specific model picks — those go stale in months.
- `docs/methodology.md` is the single source for the Discovery & Advisory Cadence and the Agent Operating Cadence. Reference it from blocks; never restate it.

## Full conventions

See `CONTRIBUTING.md` for the Definition of Done and PR process, and `docs/methodology.md` for the operating cadences every block's `AGENTS.md.example` must follow.
