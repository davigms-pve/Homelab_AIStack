# Block schema

A "block" is this repo's unit of content. Every block, present or future, follows this exact shape — what varies is which **tier** it belongs to.

## The three tiers

Blocks are organized under `blocks/` by what kind of thing they decide or build, not dumped in flat. This exists because the flat structure hid a real bug: `blocks/domains/proxmox-ai-stack/CHECKLIST.md` used to ask "which VLAN?" as if it were that block's own question, when it's a decision nothing owned. Tiering makes each block's place in the dependency order visible instead of implicit.

- **`blocks/foundation/`** — decisions nearly every domain block depends on: `host-platform` (OS/hypervisor), `network` (topology, addressing). Mostly decision-layer (Discovery & Advisory Cadence), with a thin layer of real execution once a choice is made (installing the OS, creating a bridge).
- **`blocks/core-services/`** *(named here, not yet built — see below)* — shared services domain blocks depend on but don't want to reimplement each time: a reverse proxy, internal DNS, SSO/auth. Sometimes called "platform services" in enterprise/platform-engineering vocabulary; this repo uses "core services," the term more common in homelab content, for the same thing. **No blocks exist here yet, and the directory isn't created until one does** — an empty tier folder is the stub-farm mistake this repo already avoids elsewhere. Candidates, tracked in `docs/roadmap.md`: `reverse-proxy`, `dns`, `auth-sso`.
- **`blocks/domains/`** — the end-user-facing workloads: `proxmox-ai-stack` today, media/home-automation/personal-cloud later. These are what someone actually came here to build; foundation and core-services exist to support them.

`discovery/` sits outside all three tiers — it's not a block in this sense, it's what happens before any tier is entered. `start-here/` sits outside them too, and isn't a block either: it holds the traversal instructions an agent reads to work out which tier it should be in at all. Neither carries a CEP triple, and neither should grow one.

## Files

```
blocks/<tier>/<block-name>/
├── README.md          — human entry point: what this block covers, when to use it, what it produces
├── CHECKLIST.md        — the questions an agent needs answered before it can act in this domain
├── AGENTS.md.example   — a fully filled-in reference instruction file, fake-but-realistic values
└── PLACEHOLDERS.md     — a find-and-replace map: each fake value in AGENTS.md.example, what it means, where yours comes from
```

Discovery topics under `discovery/` use the same CEP method in lighter packaging: because they're decision-only — there's no infrastructure to execute against and so no instruction file to hand an agent — each topic carries its checklist, worked example, and placeholder note as **sections inside a single file** rather than as four separate ones. `discovery/` still has its own `README.md` as the human entry point, per the rule below.

Two of the three discovery topics legitimately have nothing to swap, and say so explicitly in their Placeholders section. "No placeholders, and here's why" is a complete answer; silence is not.

## `requires:`

Every block's `README.md` states its prerequisites in a `requires:` line near the top, using the tiered path:

```
requires: [foundation/host-platform, foundation/network]
```

That's the form domain blocks use. There are four in total, because discovery topics and the graph root declare prerequisites too:

| Shape | Example | Where |
|---|---|---|
| Tiered path | `requires: [foundation/host-platform, foundation/network]` | domain block `README.md` |
| Folder name, no tier prefix | `requires: [discovery]` | both foundation blocks — `discovery/` sits outside the tier system |
| Discovery topic name | `requires: [needs]` | files inside `discovery/` |
| No prerequisite | `requires: none` | `discovery/needs.md`, the root of the graph |

**How each resolves against `.homelab-state.yml` is specified in [`../start-here/TRAVERSAL.md`](../start-here/TRAVERSAL.md)**, which is what an agent actually reads to navigate. Two rules matter enough to name here as well, because a new block has to stay compatible with them: a tiered path maps to a `blocks:` status key by **taking its last path segment**, and individual discovery topics have **no `blocks:` entry at all** — they resolve by checking whether the `decisions:` keys they produce are present. If you add a block, keep its name unique across tiers so the last-segment rule can't collide.

This exists because blocks compose: choosing media and an AI stack together changes what the hardware envelope needs to account for (storage *and* VRAM), and a domain block like the AI stack can't be reasoned about before the host platform and network are both decided. An agent — or a contributor — should be able to read `requires:` and know what has to be resolved first, and where to find it. A block with an unstated dependency is a bug — which is exactly what motivated splitting `network` out as its own foundation block in the first place.

Note: `requires:` paths and the `blocks:` keys in `.homelab-state.yml` are deliberately different shapes. `requires:` is for navigating this repo, so it uses full tiered paths. `.homelab-state.yml`'s `blocks:` map just needs unique status keys, so it stays flat (`host-platform`, `network`, `proxmox-ai-stack`) — see `docs/manifest-schema.md`.

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
