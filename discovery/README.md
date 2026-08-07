# Discovery — start here

If you own nothing yet, have no hardware picked, and maybe don't even have an AI tool: this is the right folder. Nothing here installs anything or assumes you've already chosen a technology. It's the conversation that happens *before* any of that.

Discovery exists because the alternative — jumping straight to "install Proxmox" — makes a decision on your behalf that you haven't actually made yet, and that might be wrong for what you want.

## The three topics, in order

1. **[`needs.md`](needs.md)** — what you actually want to run, how comfortable you are technically, and your real constraints (budget, space, noise, power). Everything downstream depends on this one, so it comes first.
2. **[`ai-tooling.md`](ai-tooling.md)** — what *kind* of AI tool you need to keep going. Some can run commands on real machines; some can only advise. Which one you have changes what's possible later.
3. **[`hardware-envelope.md`](hardware-envelope.md)** — turns your answers into a spec envelope ("6-8 cores, 32GB+ RAM, one free PCIe slot"), not a shopping list. Actual products get looked up from official vendor sources, because part recommendations go stale in months and this repo doesn't track them.

## How to use these

Hand the file to your AI agent and let it interview you, one question at a time. That's the intended path — these are written as agent instructions, not as an article to read straight through. If you'd rather answer them yourself first and hand the results over, that works too.

The agent should follow the **Discovery & Advisory Cadence** in [`../docs/methodology.md`](../docs/methodology.md): one question at a time, matched to how technical you said you are, explaining *why* something matters rather than just extracting an answer from you. "I don't know" is a valid answer to any of it.

## What comes out of this

A small set of confirmed decisions — which categories you want, your priority order, your comfort level, your constraints, and a hardware spec envelope — written as you go into two files in **your own** repo: `.homelab-state.yml` (machine-readable) and `HOMELAB.md` (plain language, including *why* you chose things). See [`../docs/manifest-schema.md`](../docs/manifest-schema.md).

Those decisions are what [`../blocks/foundation/host-platform/`](../blocks/foundation/host-platform/) and [`../blocks/foundation/network/`](../blocks/foundation/network/) read next, to decide what actually runs on the metal and how it's networked.

## A note on shape

These three files aren't a four-file block like the ones under `blocks/foundation/` and `blocks/domains/` — they're decision-only, so each one carries its checklist, a worked example, and its placeholder note as sections inside a single file. Same CEP method, lighter packaging. See [`../docs/block-schema.md`](../docs/block-schema.md).
