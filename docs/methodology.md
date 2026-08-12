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
5. **Execute one step at a time** — no multi-step batches without a checkpoint in between. Once a plan has been confirmed, routine steps inside it don't each need narrating; what needs a checkpoint is anything state-changing.
6. **Stop at surprises.** An error, an unexpected result, or a premise that turns out to be false mid-plan is a decision fork to surface — never something to route around silently to finish what was agreed. The plan was approved on the strength of the premise; if the premise died, so did the approval. **"Stop and re-plan" is a successful outcome of this cadence, not a failure of it** — a restart withheld because the evidence disproved the theory behind it is the cadence working.
7. **Verify against a live artifact** — a real request that returns the expected result, a trace, a log line from the running service. Not the absence of errors, not a green status, not output that merely looks right, and never documentation or plausibility. A service can start cleanly having silently loaded nothing; a `git pull` without a restart leaves the old code serving while everything looks deployed.
8. **Report** — a plain summary of what changed and where things stand now.

**Two things are owner-only, regardless of how much autonomy an agent has been granted:** obtaining new credentials or access for itself, and interactive authentication flows. Draft exactly what needs doing and hand it over; never perform them. This is not covered by the stop-and-confirm gate — that gate governs actions the agent then takes, and these are actions it doesn't take at all.

## Validation: the rungs

You can't dogfood a contributor's hardware, and pre-1.0 this repo frequently can't dogfood its own either. What it can do is say *how much* checking a block has had — so that "not verified" stops meaning the same thing for a block nobody has ever read against a vendor doc and a block that's been walked line by line against a running deployment.

**The axis is how strongly anyone has checked this against reality — never who wrote it.** First-party blocks climb the same ladder as third-party ones. What changed from the earlier three-outcome split is only resolution: three buckets flattened real differences in trustworthiness, which both oversold the weakest content and undersold the strongest.

Every block sits on exactly one rung, declared in its `AGENTS.md.example` frontmatter. **Every rung above L0 names an evidence artifact, and a rung claimed without its artifact isn't a rung.** That's the load-bearing part: a label anyone can apply by feeling confident is worth nothing. `.github/workflows/validate-blocks.yml` checks the shape mechanically.

| Rung | Means | Evidence artifact |
|---|---|---|
| **L0** | Written from official documentation and reasoning. Nobody has checked it against anything. | none — L0 is the honest absence of evidence |
| **L1** | **Desk-checked.** Every command, flag, and prerequisite read against the vendor's current official docs on a stated date. Nothing executed. | the date, plus the exact versions checked against |
| **L2** | **Retro-validated.** Walked item by item against a real, already-running deployment, with a divergence log recording every place the block and that deployment disagree. | the divergence log |
| **L3** | **Executed.** The block's command paths were actually run, start to finish, in a named environment — with a list of every checklist item that environment structurally could not reach. | the run record, including its `unreached` list |
| **L4** | **Reproduced.** Someone who didn't write the block followed it on their own hardware and got a working result. | their dogfood report |

Three things about this that aren't obvious:

**L2's product is divergences, not agreement.** Where a block was informed by the deployment it's being checked against, agreement proves very little — the block may just be describing that one machine back to itself. Divergence is the strong signal, and each one forces a decision on record: is the block wrong, or is this deployment idiosyncratic? **A retro-validation that produces zero divergences has almost certainly not been done item by item**, and reads as suspect rather than clean.

**L3 is not a claim of completeness — `unreached` is what makes it honest.** Commands can be genuinely executed in an environment that structurally cannot test parts of the block: nested virtualization runs a real platform install and real VM-creation commands while proving nothing about GPU passthrough, IOMMU grouping, firmware settings, or physical disks. That's still far stronger evidence than desk-checking, and it stays honest only if the residue is written down. **`unreached: none` is the bare-metal condition** — and it's what `1.0` requires.

**A block may hold evidence from several rungs.** L1 and L2 check different things; frontmatter records the highest reached and `evidence:` keeps the rest. Rungs are never claimed because a block *feels* well-founded.

### Frontmatter

```yaml
---
verification: L2
last-verified: 2026-08-12
verified-against: proxmox-8.4 / docker-compose-2.29
evidence: docs/evidence/proxmox-ai-stack-divergences.md
---
```

The rules, all of them mechanically checkable:

- `verification` is exactly one of `L0` `L1` `L2` `L3` `L4`.
- At **L0**, `last-verified`, `verified-against`, and `evidence` are all `n/a`. Nothing else is truthful.
- At **L1 and above**, `last-verified` is an ISO date and `verified-against` names concrete versions.
- At **L2 and above**, `evidence` points at a real file in this repo or a stable URL.
- At **L3 and above**, an `unreached:` key is present — either `none` or a list of the checklist items that environment couldn't test.

### What ships, and what 1.0 needs

**L0 and L1 are legitimate pre-1.0** — but only stated out loud, in the block's own `README.md` as well as its frontmatter, with the gap tracked in [`roadmap.md`](roadmap.md). Shipping a low rung is fine; shipping one *quietly* is the thing this repo doesn't do. `1.0` requires one complete path at **L3 with `unreached: none`**, or at L4.

### Guidance quality is a separate axis

The rungs measure whether a block's *content* is correct. They say nothing about whether an agent handed `start-here/TRAVERSAL.md` actually routes a real person well — asks the right questions in the right order, notices a missing block, produces the manifest files. That needs a cold reader, not cold hardware, and it's testable today at no cost: hand the traversal to a fresh session with a novice persona and record where it gets lost. **The transcript is the evidence artifact**, and the defects it finds are tracked in `roadmap.md` rather than in any block's frontmatter — `discovery/` and `start-here/` carry no rung, because they have no commands to be wrong about.

See `CONTRIBUTING.md` for the Definition of Done these map to.

## Official sources only

Where a block links to a runnable stack, the link must point at an official or vendor source (the project's own repo/docs), never a third-party reimplementation or random fork. This is what makes the "bring-your-own-infra" approach trustworthy without this repo owning any infrastructure itself.
