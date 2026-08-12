# Checklist — agent operations

What an agent needs settled before it can keep someone's homelab true over months, rather than merely build it once.

Follow the **Discovery & Advisory Cadence** in `../../../docs/methodology.md` for the two questions; everything after them is contract, not conversation.

## The two questions

1. **Where do findings go?** When a session discovers something real — a measured constant, a dead end already ruled out, a service that behaves differently than documented — what's the durable home for it?
   - `github-issues` — they already run a tracker on their own repo.
   - `homelab-md` — no tracker. Findings become dated entries in `HOMELAB.md` with a stable id (`2026-08-12-gpu-idle-draw`), and `.homelab-state.yml` references them by that id.
   - Record as `decisions.operations.findings_tracker`. **Do not skip this by assuming a tracker exists** — most people following this repo will have a folder and a git repo, nothing more.

2. **How often does the maintenance pass run?** Monthly is the default and a fine answer. Record as `decisions.operations.audit_cadence`, and the date of the last one as `audit_last_run`.

## The state-file contract

`.homelab-state.yml` decays into a session journal unless something stops it. State these rules in the user's own `AGENTS.md`, and hold them:

- [ ] **No narrative sections, ever.** History belongs to `HOMELAB.md` and to git. If a sentence explains *why*, it is in the wrong file.
- [ ] **Every open item carries a reference** — an issue number, or a `HOMELAB.md` finding id. An open item with no reference is how findings disappear.
- [ ] **"What to do next" is capped at three items.** More than three is a backlog, and a backlog belongs in the tracker.
- [ ] **One bounded `handoff:` section** where a session that runs out of time parks unrouted items as one-liners — and **the next session's first task is to drain it**, before any new work. A handoff section nobody drains is just a slower journal.
- [ ] Enforce this with **structure, not a line limit**. Compression fails by silently deleting load-bearing facts and you never learn which; bloat fails visibly and is repairable at the next pass. Structural rules also survive a weak session, because they need shape-matching rather than judgment about what to cut.

## Routing a finding

Three destinations, chosen **at the moment of discovery** — never "I'll write it up at the end," because the session may not have an end it controls:

- [ ] **Evidence and reproduction** → the tracker, or a dated `HOMELAB.md` finding with an id.
- [ ] **The human summary and the *why*** → the `HOMELAB.md` log.
- [ ] **Operative facts** — measured constants, do-not-do warnings, environment gotchas — → **the user's own `AGENTS.md`**, the one file every session loads at start.

That third route is the one that gets skipped, and it's the one that matters: a fact written only into session narrative looks recorded and then leaves with the story it was embedded in. A finding that lives only in prose is a finding lost.

## Decisions get written before they're executed

- [ ] The order is **investigate → evidence → decision record → execute**, never the reverse. A decision record written afterwards drifts into justification for what already happened.
- [ ] For anything with real blast radius, the record is a `HOMELAB.md` entry written *before* the change, naming the plan, the expected result, and the rollback.
- [ ] A record is **never silently edited**. Supersede it with a new dated entry, or amend it with a dated note. What was believed when has to stay legible.
- [ ] **Two things stay owner-only regardless of how much autonomy the agent has:** granting the agent new credentials or access, and interactive authentication flows. Draft them, hand them over, never perform them.

## Verification: what actually counts as proof

Deploys lie, logs lie, and plausible output lies. Each of these came from a separate real incident:

- [ ] A change is proven by a **live artifact** — a real request that returns the expected result, a trace, a log line from the running service. Never by output that merely looks right.
- [ ] **Absence of errors is not evidence.** A recreated container started with a clean log while having silently lost its config and loaded nothing at all; only a real end-to-end request exposed it.
- [ ] **Documentation, precedent, and a plausible hypothesis are not evidence.** "It's probably contention" survives right up until real data disproves it.
- [ ] **A pull without a restart changes nothing.** The old code is still running and everything looks deployed.
- [ ] Every state-changing checklist item in your own repo should read **"done when: <live artifact>"**, not "verify it worked."

## Secrets follow the direction the file travels

One question settles every redaction decision: **which way does this file flow?**

- [ ] **Live → repo** (the repo copy is a backup or mirror): redact before staging, grep the staged diff for key patterns, and **never copy the redacted mirror back over the live file**.
- [ ] **Repo → live** (the repo copy is what deploys): **never redact** — placeholders would ship to production. Protect these by externalizing secrets into env or ignored files instead.
- [ ] Every mirrored file carries a **provenance header naming its direction**, so no future session has to guess.
- [ ] Secret scanning on push is the net underneath, not a substitute for the rule.

## The maintenance pass

On the recorded cadence, with a fixed list — reviews that happen "when something feels off" happen late:

- [ ] Closed-item audit: is everything marked done actually done?
- [ ] State-file contract check against the rules above.
- [ ] Doc-drift spot-check: does `HOMELAB.md` still describe the system that exists?
- [ ] Orphaned-finding sweep: anything discovered but never routed.
- [ ] **Check the other direction too.** Bloat is easy to see. Context that's too *thin* shows up as a session re-making a mistake already recorded, or re-trying a dead end already ruled out. Each hit means required context didn't reach the working session — diagnose whether the fact was **missing** from the file every session loads (a routing failure) or **present but unread** (a pointer-following failure), and fix the routing rather than the instance.

## Write for the weakest session that will ever read this

- [ ] A duty must appear in the checklist **that is actually walked at the moment it applies**. Knowledge distributed across several files reliably fails.
- [ ] State duties **at the point of use, even if that means saying them twice** — session start *and* session end.
- [ ] Keep each pointer hop small, put the reference **on** the line being acted on, and keep universally-needed facts in the one file every session loads rather than behind a link.
- [ ] Prefer instructions that need **shape-matching** ("≤3 items", "must carry a finding id", "drain this first") over instructions that need judgment ("keep it concise", "use your best sense"). The second kind degrades with the session following it.
