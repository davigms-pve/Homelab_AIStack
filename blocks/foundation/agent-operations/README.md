# Agent operations

requires: [discovery]

*Foundation-tier block — see `docs/block-schema.md` for what that means.*

Every other block in this repo takes you from *nothing* to *something running*. This one is about the months afterwards, when a different session on a different day with different context loaded picks up your homelab and has to not break it.

That stretch is where the repo previously stopped. `docs/manifest-schema.md` says how `.homelab-state.yml` and `HOMELAB.md` get **written**; nothing said how they stay true a year later. The honest answer, from a real deployment operated this way for months: they don't, unless something structural makes them.

## The one thing this block is really about

**A rule that isn't mechanically enforced will be broken by a future session.**

Not might be — will be. Sessions are run by different models on different days with different context loaded, and a written convention is advice to all of them. The deployment this block comes from repeated one specific mistake four times, twice *after* the rule was prominently documented; what finally ended it was a small guard that made the mistake structurally impossible, not better wording.

So the question this block keeps asking is: where your instructions say "never do X," can X be made impossible or self-correcting instead of prohibited?

## What this block produces

- **A structural contract for `.homelab-state.yml`** — what may appear in it, what may not, and a bounded handoff section with a drain rule, so it stays a pointer instead of decaying into a session journal.
- **A findings-routing rule** — where a discovery goes *at the moment it's found*, with a form that works whether or not you have an issue tracker.
- **A verification standard** — what counts as proof a change actually landed, given that deploys, logs, and plausible-looking output all lie.
- **A secrets rule keyed to the direction a file travels**, which is the only version of that question with a reliable answer.
- **A maintenance pass on a fixed cadence** that checks drift in both directions — too much context *and* too little.
- `decisions.operations` in your state file: where findings go, and how often the maintenance pass runs.

## When to use this

**First of the foundation blocks, right after discovery** — before `host-platform`, not after the domain block is running.

That ordering looks odd for a day-2 block, and it's deliberate: your two tracking files get their first lines written *during discovery*, and a contract adopted after they've already grown is a cleanup job rather than a contract. It costs one short conversation. Nothing here blocks anything.

## This block is thin on questions and heavy on rules

Like `hardware-bringup/`, most of what's here isn't asked of you — it's how your agent is told to behave, and it lands in the `AGENTS.md` in your own repo. There are two real questions (where findings go, how often the maintenance pass runs) and the rest is the operating contract.

If that makes the checklist look short, that's the design. The value is the contract, not the interview.

## Skipping it

Mark it `excluded` if you already operate under your own conventions — an established `AGENTS.md`, your own way of tracking findings, your own maintenance habit. That's a real choice, and this block has no interest in overwriting something that already works.

What it isn't is a free skip. Every later session writes to `.homelab-state.yml`, and nothing else in this repo governs how that file stays true — so excluding this block means *your* contract applies, not *no* contract. Record which one in `HOMELAB.md` so a future session knows the rules it's under. `start-here/TRAVERSAL.md` checks for exactly that before letting an `excluded` status satisfy a domain block's prerequisites.

## Validation

**Rung L0 — never run.** See the ladder in `docs/methodology.md`.

One honest note specific to this block: its content comes from a real deployment operated by AI agents for months (see `docs/field-evidence.md`), which is stronger provenance than the other blocks have — and provenance is not a rung. Nobody has yet adopted this contract in a fresh repo and reported back on whether it holds there. Until someone does, `L0` is the truthful label, however well-sourced the rules are.

The ladder fits this block poorly — there is no vendor to desk-check it against, and its real test is whether the contract holds across months of sessions. So its meaningful evidence sits on the guidance-quality axis, not the rungs; see "Guidance quality is a separate axis" in `docs/methodology.md`.
