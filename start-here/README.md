# Start here

This folder holds one thing: the file you hand your AI agent first.

Everything else in this repo is content an agent works *through* — discovery topics, foundation blocks, a domain block. [`TRAVERSAL.md`](TRAVERSAL.md) is what tells it how to move between them: read your current state, work out what's already decided, figure out what has to happen before what, and open the right file next.

## How to use it

Point your agent at [`TRAVERSAL.md`](TRAVERSAL.md) and let it take over from there. Something as plain as this works:

> Read `start-here/TRAVERSAL.md` in this repo and follow it.

You don't need to read it yourself first, though nothing stops you — it's short. It ends by handing off to whichever block comes next, so a fresh session picks up where the last one stopped rather than re-interviewing you.

## Why this exists as its own folder

Without it, an agent handed this repo has to *infer* the order — that discovery comes before the foundation blocks, that all four foundation blocks come before any domain block, that they run in a particular order, and that a half-finished decision is worse than an unstarted one. Inferring works right up until it doesn't, usually somewhere expensive.

It's a separate folder rather than a root file because the repo's root `AGENTS.md` is for people editing *this repo*, and two files with opposite audiences sitting next to each other is how the wrong one gets opened.

## What this is not

Not a block. There's no checklist, no filled example, no placeholder map here, because there's nothing to adapt — you don't fill this file in, your agent just follows it. Blocks are the things with the CEP triple; see [`../docs/block-schema.md`](../docs/block-schema.md).

It also doesn't govern how your agent behaves. The stop-and-confirm gate, the "propose the safer path first" rule, and the one-question-at-a-time interviewing style all live in [`../docs/methodology.md`](../docs/methodology.md), and `TRAVERSAL.md` points at them rather than repeating them.
