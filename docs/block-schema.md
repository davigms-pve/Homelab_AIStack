# Block schema

A "block" is this repo's unit of content — a discovery topic, a foundation decision, or a domain (like an AI stack). Every block, present or future, follows this exact shape.

## Files

```
blocks/<block-name>/
├── README.md          — human entry point: what this block covers, when to use it, what it produces
├── CHECKLIST.md        — the questions an agent needs answered before it can act in this domain
├── AGENTS.md.example   — a fully filled-in reference instruction file, fake-but-realistic values
└── PLACEHOLDERS.md     — a find-and-replace map: each fake value in AGENTS.md.example, what it means, where yours comes from
```

Discovery topics under `discovery/` use the same CEP method in lighter packaging: because they're decision-only — there's no infrastructure to execute against and so no instruction file to hand an agent — each topic carries its checklist, worked example, and placeholder note as **sections inside a single file** rather than as four separate ones. `discovery/` still has its own `README.md` as the human entry point, per the rule below.

Two of the three discovery topics legitimately have nothing to swap, and say so explicitly in their Placeholders section. "No placeholders, and here's why" is a complete answer; silence is not.

## `requires:`

Every block's `README.md` states its prerequisites in a `requires:` line near the top, e.g.:

```
requires: [discovery, host-platform]
```

This exists because blocks compose: choosing media and an AI stack together changes what the hardware envelope needs to account for (storage *and* VRAM), and a domain block like the AI stack can't be reasoned about before the host platform is decided. An agent — or a contributor — should be able to read `requires:` and know what has to be resolved first. A block with an unstated dependency is a bug.

## Filled example, not blank template

`AGENTS.md.example` is not a fill-in-the-blanks form. It's a complete, working instruction file using invented-but-plausible values (a fake hostname, fake VM IDs, a fake GPU address) written inline, exactly where a real value would go. Someone adapting it does a find-and-replace using the table in `PLACEHOLDERS.md`, and sees the finished shape the whole time rather than staring at an empty skeleton.

This is the rule most easily broken by accident. A file full of `<<NODE_NAME>>` tokens looks like a template and passes a casual glance, but it's the exact failure mode this repo exists to argue against — an agent handed `pvesh get /nodes/<<NODE_NAME>>/qemu` has learned nothing it didn't already know. If a reviewer can't read the example start to finish as though it were somebody's real, working `AGENTS.md`, it isn't done.

## Referencing methodology, not restating it

`AGENTS.md.example` should point at `docs/methodology.md` for the Discovery & Advisory Cadence or Agent Operating Cadence rather than copying those steps into every block. This keeps each block short — which matters, because long agent context files are exactly what stops working.

## Validation frontmatter

`AGENTS.md.example` carries, once validated:

```yaml
last-verified: 2026-08-06
verified-against: proxmox-8.2 / docker-compose-2.29
```

A block without current frontmatter is marked **unverified** in its `README.md`. See `docs/methodology.md` for the validation rules this maps to.
