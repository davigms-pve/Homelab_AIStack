# Methodology

This is the one place these rules are written. Every block references this file rather than restating it — that's what keeps individual `AGENTS.md.example` files short enough to actually work as agent context.

See [`../DISCLAIMER.md`](../DISCLAIMER.md) for the risk this methodology exists to manage — real infrastructure, real consequences, no warranty.

## The CEP method

A generic instruction file ("describe your Proxmox cluster here") gives an agent nothing to act on. Good agent instructions are short, specific, and written for one real environment. So every block in this repo ships as three parts:

1. **Checklist** — the exact facts an agent needs to be competent in this domain (node names, GPU PCI address, VLAN layout, what must never be touched). A question list, not prose.
2. **Example** — a fully filled-in reference using realistic-but-fake values, so a reader sees what "good" looks like once the checklist is answered.
3. **Placeholders** — the swap convention, so it's unambiguous what to replace with real values.

A block missing any of the three isn't done. See `block-schema.md` for the formal structure and the `requires:` field that lets blocks compose.

## Two cadences, two different postures

These get blurred together easily but they govern opposite things: one is about *eliciting* information from a person, the other is about *executing* against real infrastructure. Keep them separate.

### Discovery & Advisory Cadence

Governs any decision-only stage — `discovery/`, `blocks/foundation/` blocks, or any future block that's about choosing rather than doing.

1. **One question or topic at a time.** Never front-load an entire checklist as a form. Ask, listen, let the answer shape what's asked next.
2. **Calibrate to stated comfort level immediately.** The first thing discovery should establish is how technical the person is, and every later question adjusts its own depth and jargon to match.
3. **Explain the "why" briefly on anything non-obvious.** Why VRAM matters, why transcoding changes CPU needs. Teach as you go, don't just extract answers.
4. **"I don't know" is valid input, not a blocker.** Offer the common-case default, state the tradeoff, move on. Never stall on one unanswered item.
5. **Summarize the emerging decision set back periodically** — "so far: media + AI stack, comfortable with Docker, budget under $800" — so the person can correct course before too much gets assumed.
6. **Show the resulting artifact and let the person edit it, then persist immediately on confirmation.** Each confirmed decision is written to `.homelab-state.yml` and `HOMELAB.md` (together, see `manifest-schema.md`) the moment it's confirmed — never batched until the end of a session. A session that ends mid-discovery should lose nothing.
7. **Hand off explicitly.** Once decisions are confirmed and written, say so plainly — "discovery complete, moving to execution mode for the host-platform block" — that's the exact boundary where the Operating Cadence below takes over.

### Agent Operating Cadence

Governs any stage where the agent is acting on real infrastructure, where a wrong `docker compose down` or a deleted VM costs real uptime or data.

0. **Confirm the standing methodology agreement is on record.** Before anything else, check `.homelab-state.yml` for `decisions.methodology_agreed`. If it's not there: present the terms plainly — the stop-and-confirm gate is non-negotiable, a safer path (backup or sandbox) will be suggested before risky changes where one exists, and point at `DISCLAIMER.md` for the full risk picture — then get explicit human agreement before proceeding with anything else. Record it once (`decisions.methodology_agreed: true` plus a one-line `HOMELAB.md` log entry) so later sessions don't re-ask, but this check itself never gets skipped. This applies **regardless of whether the surrounding tool or harness auto-approves actions** — it's a textual gate this repo's instructions require, not a substitute for one, and it holds even when nothing external is prompting for confirmation. See `DISCLAIMER.md` for why this matters independent of any particular tool's settings.
1. **Read current state first** — inspect actual state (`docker ps`, compose file contents, node list, `.homelab-state.yml`) before proposing anything. Never assume.
2. **Summarize understanding back** — state what was found before acting, so a human can catch a wrong read.
3. **Propose a plan — and propose the safer path alongside it.** For anything beyond a read-only query, state the exact commands or changes before running them. Before a state-changing action, also check whether a snapshot/backup of what's about to change is possible, and whether a sandboxed or test-first version exists (a throwaway VM/container, a dry-run flag, applying to a non-critical resource first) — offer it as part of the same proposal. This isn't a one-time check: it applies every time something is about to be built or altered, not just at the start of a session. If no safer path exists for this particular action, say so explicitly rather than silently skipping the question.
4. **Stop-and-confirm gate** — explicit human confirmation before any state-changing action. Non-negotiable before anything destructive or hard to reverse (deletes, restarts, `down`).
5. **Execute one step at a time** — no multi-step batches without a checkpoint in between.
6. **Verify** — check the actual result (service healthy, container up, VM running) rather than assuming success.
7. **Report** — a plain summary of what changed and where things stand now.

## Validation and staleness

You can't dogfood a contributor's hardware. Validation is two-tiered:

- **First-party blocks** are exercised in an actual live agent session before merge — that session *is* the test.
- **Third-party contributions** carry frontmatter on the filled example:
  ```
  last-verified: 2026-08-06
  verified-against: proxmox-8.2 / docker-compose-2.29
  ```
  Anything without current frontmatter is marked **unverified** in its `README.md`. See `CONTRIBUTING.md` for the Definition of Done this maps to.

## Official sources only

Where a block links to a runnable stack, the link must point at an official or vendor source (the project's own repo/docs), never a third-party reimplementation or random fork. This is what makes the "bring-your-own-infra" approach trustworthy without this repo owning any infrastructure itself.
