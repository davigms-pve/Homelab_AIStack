# Start here

This folder holds one thing: the file you hand your AI agent first.

Everything else in this repo is content an agent works *through* — discovery topics, foundation blocks, a domain block. [`TRAVERSAL.md`](TRAVERSAL.md) is what tells it how to move between them: read your current state, work out what's already decided, figure out what has to happen before what, and open the right file next.

## How to use it

Point your agent at [`TRAVERSAL.md`](TRAVERSAL.md) and let it take over from there. Something as plain as this works:

> Read `start-here/TRAVERSAL.md` in this repo and follow it.

You don't need to read it yourself first, though nothing stops you — it's short. It ends by handing off to whichever block comes next, so a fresh session picks up where the last one stopped rather than re-interviewing you.

## Works with any agent — and what to do when yours is different

Nothing in this repo depends on a particular AI tool. It's plain Markdown and plain YAML, with no tool-specific commands, plugins, or syntax, so any assistant that can follow written instructions can use it. Two practical differences between tools are worth knowing:

- **Which instructions file your agent reads.** Here, and in the files your agent creates for your own homelab repo, the instructions live in `AGENTS.md` — the most widely shared convention. Some tools read a differently named file instead. If yours does, don't copy the contents: create the file your tool reads and put one line in it saying "the instructions for this repo are in `AGENTS.md`; read that." This repo does exactly that with its own `CLAUDE.md`. One copy of the rules means nothing drifts.
- **Whether your assistant can open files at all.** A chat-only assistant can't read this repo or write your state files. Paste `TRAVERSAL.md` into the conversation and paste the others as it asks for them; it will hand you the contents of `.homelab-state.yml` and `HOMELAB.md` to save yourself, and ask for them back next session. That's enough to finish discovery. Doing anything to a real machine needs an agent that can run commands — see [`../discovery/ai-tooling.md`](../discovery/ai-tooling.md).

## Why this exists as its own folder

Without it, an agent handed this repo has to *infer* the order — that discovery comes before the foundation blocks, that all four foundation blocks come before any domain block, that they run in a particular order, and that a half-finished decision is worse than an unstarted one. Inferring works right up until it doesn't, usually somewhere expensive.

It's a separate folder rather than a root file because the repo's root `AGENTS.md` is for people editing *this repo*, and two files with opposite audiences sitting next to each other is how the wrong one gets opened.

## What this is not

Not a block. There's no checklist, no filled example, no placeholder map here, because there's nothing to adapt — you don't fill this file in, your agent just follows it. Blocks are the things with the CEP triple; see [`../docs/block-schema.md`](../docs/block-schema.md).

It also doesn't govern how your agent behaves. The stop-and-confirm gate, the "propose the safer path first" rule, and the one-question-at-a-time interviewing style all live in [`../docs/methodology.md`](../docs/methodology.md), and `TRAVERSAL.md` points at them rather than repeating them.
