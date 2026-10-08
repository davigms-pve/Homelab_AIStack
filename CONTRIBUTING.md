# Contributing

Fork, branch, PR. Nothing unusual there. What's specific to this repo is what a contribution has to include before it's mergeable.

## Definition of Done

A new or edited block is done when:

- [ ] It's a complete **CEP triple** — `README.md`, `CHECKLIST.md`, `AGENTS.md.example`, `PLACEHOLDERS.md` all present (see `docs/block-schema.md`).
- [ ] **`AGENTS.md.example` reads as a finished file, not a form.** Realistic fake values inline, no `<<TOKEN>>` placeholders left in it. A reviewer should be able to read it start to finish as though it were somebody's real, working `AGENTS.md`. This is the checklist item most easily passed by accident — file presence is not the test.
- [ ] `PLACEHOLDERS.md` is a find-and-replace map: each fake value, what it means, where the reader's own value comes from.
- [ ] The `CHECKLIST.md` would actually let an agent finish the job. Ask concretely: given only this block, would an agent know how to *reach* the infrastructure, and what could it destroy by following the steps in order?
- [ ] It declares its `requires:` prerequisites honestly, if any.
- [ ] `AGENTS.md.example` references `docs/methodology.md`'s cadences rather than restating them.
- [ ] It declares a **verification rung** (`L0`–`L4`) in its `AGENTS.md.example` frontmatter *and* in plain words in its `README.md` — see `docs/methodology.md`. `L0` is a perfectly acceptable answer; an absent or overstated one isn't. Anything above `L0` names an evidence artifact that actually exists.
- [ ] Any `assumes:` tag it declares ships with a stated fallback. A bare assumption is a bug — see `docs/block-schema.md`.
- [ ] Any values in `AGENTS.md.example` are fake-but-realistic. No real IPs, hostnames, tokens, or serial numbers.
- [ ] Discovery and hardware/tooling content states criteria, not brand picks — see `docs/index.md` for why.
- [ ] Nothing an agent is told to do depends on one AI tool's features — describe capabilities ("an agent that can run shell commands"), not products, slash commands, plugins, or permission modes. A known-names tripwire in CI catches the obvious cases; the rest is review.

## Link-vetting rule

Any link to a runnable stack, tool, or piece of software must point at its official/vendor source — the project's own repository, own documentation, or own release page. Do not link third-party reimplementations, unofficial mirrors, or random blog forks, even if they're popular. Reviewers check this on every PR that adds a link.

## Adding a new block

New categories are welcome — see `docs/roadmap.md` for what's already planned. Figure out which tier it belongs in first (`docs/block-schema.md`): `blocks/foundation/` for decisions nearly everything depends on, `blocks/core-services/` for shared services like a reverse proxy or DNS, `blocks/domains/` for end-user-facing workloads like media or home automation. Follow the existing blocks (`blocks/foundation/host-platform/`, `blocks/foundation/network/`, `blocks/domains/proxmox-ai-stack/`) as the reference shape rather than inventing a new structure.

## What CI checks, and what it can't

`.github/workflows/validate-blocks.yml` runs on every push and pull request. It enforces the mechanically checkable half of the list above: every block has its four files, every `AGENTS.md.example` carries well-formed verification frontmatter whose fields agree with its rung, no `<<TOKEN>>` placeholder survives in a filled example, every `requires:` name resolves to a block or discovery topic that exists, and agent-facing content (`blocks/`, `discovery/`, `start-here/`) names no specific AI product.

This split is deliberate, and it comes from field experience: **a rule that isn't mechanically enforced gets broken by a future contributor, or a future session, no matter how prominently it's written down.** Everything above that a machine can check, a machine checks. What's left for human review is genuinely judgment — whether the example *reads* as a finished file, whether the checklist would actually let an agent finish the job, whether guidance stayed criteria rather than picks. Don't add checklist items that a script could enforce; write the script instead.

## What happens to a filed issue

This repo tracks its own open work as gaps in `docs/roadmap.md`, not as GitHub issues — deliberately, because an agent handed this repo reads that file and does not go looking for an issue tracker. Issues are the **inbound** path, and they need routing or they stop at the website:

- **A block gap or inaccuracy** becomes a numbered `G` gap in `docs/roadmap.md`, linked back to the issue. The issue can then be closed; the gap is the durable record.
- **A dogfood report** is evidence, and it's the only route to `L4`. Its findings split the same way any finding does: corrections go into the block, anything unresolved becomes a gap, and the report itself is the artifact a rung points at — so it stays open, or gets linked from `evidence:`, rather than being summarized and discarded.
- **Either one arriving with no roadmap entry afterwards is the failure mode**, not a backlog. Someone took the trouble to tell you what broke; a thank-you and a closed tab loses it.

Gap ids are stable and never reused, so a link to one stays valid after later gaps close.

## Pull requests

Use the PR template — it includes the same checklist above as an attestation. A reviewer should be able to check every box against the diff without guessing. Boxes CI already covers are marked as such, so review attention goes to the ones it can't.
