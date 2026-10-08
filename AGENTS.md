# AGENTS.md — working in this repo

This file governs an AI agent working **on this repository itself** (adding or editing blocks, docs, discovery content). It does not govern homelabs built from it — those instructions live in each block's own `AGENTS.md.example`, generated per user.

## What this repo is

A set of reusable AI-agent instruction templates that help an AI assistant guide someone from "found this repo, own nothing yet" through discovering what they want, choosing hardware and tooling, and operating real homelab infrastructure. It is not a runnable docker-compose product and not a curated link list — see `docs/index.md`.

## The one rule that matters most

Every template (a "block") ships as a **CEP triple**: a **C**hecklist of what an agent needs to know, a filled **E**xample using fake-but-realistic values, and a **P**laceholders map saying what to find-and-replace. A block missing any of the three is incomplete — see `docs/block-schema.md`.

The **E** is the part that gets hollowed out by accident. A filled example means realistic values written inline, exactly where a real value would go — `pve1`, `01:00.0`, VM `105` — so the file reads as somebody's finished, working `AGENTS.md`. An example full of `<<NODE_NAME>>` tokens is the generic-prose-with-blanks failure this whole repo argues against, wearing the right filename. If you can't read it start to finish as a real file, it isn't done.

## Conventions

- Every folder that holds agent-oriented data (`CHECKLIST.md`, `AGENTS.md.example`, `TRAVERSAL.md`) also holds a plain-language `README.md` as the human entry point. Don't add one without the other.
- Blocks declare a `requires:` list of prerequisite blocks. Never write a block that silently assumes a prior decision. Declaring isn't enough on its own — `start-here/TRAVERSAL.md` specifies how those declarations resolve against `.homelab-state.yml`, so a new block has to keep its name unique across tiers and document which `decisions:` keys it writes.
- The `.example` suffix means "filled template, adapt it via `PLACEHOLDERS.md`." Don't use it for files an agent follows verbatim — that's what `start-here/TRAVERSAL.md` is, and why it isn't named `AGENTS.md.example`.
- Any link to a runnable stack must point at an official/vendor source (see `CONTRIBUTING.md`). Never link a third-party reimplementation.
- Discovery and hardware/tooling guidance state *criteria*, never brand rankings or specific model picks — those go stale in months.
- `docs/methodology.md` is the single source for the Discovery & Advisory Cadence and the Agent Operating Cadence. Reference it from blocks; never restate it.
- `DISCLAIMER.md` states the risk this whole methodology exists to manage, and the Agent Operating Cadence's step 0 (standing methodology agreement) applies regardless of harness auto-approval settings. Don't weaken either without understanding why they're there.

- **This repo is agent-agnostic, and the content must stay that way.** Nothing a block, discovery topic, or `start-here/` file tells an agent to do may depend on one tool's features — no slash commands, skills, plugins, hooks, tool-server protocols, permission modes, or product names. Describe a *capability* ("an agent that can run shell commands") rather than a tool. A new block that only works in one agent has quietly become that agent's block. `validate-blocks.sh` checks for a list of known product names in agent-facing content; that is a tripwire, not a guarantee, since it can't know tools it hasn't been told about — review has to catch the rest.
- **`AGENTS.md` is the one canonical instructions file; a tool-specific filename is only ever a pointer.** `CLAUDE.md` exists because one tool reads that name and nothing else, and says so. If another tool needs the same, add the same kind of one-line pointer file — never a second copy of the rules, which is how two instruction files come to disagree.

## Full conventions

See `CONTRIBUTING.md` for the Definition of Done and PR process, and `docs/methodology.md` for the operating cadences every block's `AGENTS.md.example` must follow.

## Working alongside other agents (and the humans reviewing them)

This repo is maintained with AI agents doing real work in it — more than
one, sometimes concurrently. The rules below are what keep that from
turning into a mess. They apply to **any** agent operating here, not just
the one that happens to read this file first.

**This repository is public.** A mistake merged here is visible
immediately and may be cloned, forked, or quoted before it is reverted.
That is the reason the merge rule below is absolute rather than
situational.

- **Never push to `main`. Never merge your own work.** Open a pull
  request and stop there. Only the maintainer — reviewing alongside
  whatever AI review assistance they use — merges to `main`. This holds no matter how small, obvious, or
  self-evidently correct the change looks. It is the review step that
  catches a plausible-looking change that is simply wrong, which is the
  failure mode an agent produces most often and can least detect in
  itself.
- **If your tooling has a default workflow that ends in a merge, that
  default does not apply here.** Some agent skills document a
  branch → commit → PR → `gh pr merge --squash` sequence as the normal
  end of a task. Stop at the PR. This line exists because that default is
  real and is otherwise unopposed in this repo.
- **One branch per contributor; one branch per agent.** Human-only work
  goes on `<handle>/<topic>`. Agent work goes on
  `<agent>/<handle>/<topic>` — e.g. `claude/davigms-pve/block-schema-fix`,
  `hermes/davigms-pve/link-audit`. When a person is working *with* an
  agent, the agent gets its own branch rather than sharing the person's,
  so conflicts and attribution stay separable. Branches that predate this
  convention remain valid; don't rename them.
- **Never edit `.github/workflows/`.** `validate-blocks.yml` is the
  mechanical half of the Definition of Done — the backstop that catches
  what review misses. An agent that can weaken the net and then rely on
  the weakened net in the same run has no backstop at all. Propose
  workflow changes in an issue instead.
- **Never force-push**, and never `rm -rf` outside your own working tree.
- **Never grant credentials or access** to yourself or anyone else.
- **Report honestly.** If CI fails, say so and quote it. If you skipped
  something, say which part. A block that "looks right" is not a block
  that was verified — this repo's whole argument is that unenforced
  claims decay (`CONTRIBUTING.md`, "What CI checks, and what it can't").

**None of this is enforced by GitHub.** There is no branch protection on
this repo; an agent's credentials permit the push and the merge it is
told here not to perform. These rules hold only because the agent reads
this file and follows it. That is a deliberate choice by the maintainer —
governance through instructions rather than through narrowed
credentials — and it means the honesty of an agent working here is doing
real load-bearing work, not decorative compliance.
