# Roadmap, build cadence, and open gaps

**This repo is pre-1.0 and openly a work in progress.** No version has been declared working yet. This page is where that's tracked honestly — what's built, what's next, what's known to be incomplete, and what would have to be true to call a version done.

Two other cadences exist and are different from this one: the **Discovery & Advisory Cadence** (how an agent guides a person through decisions) and the **Agent Operating Cadence** (how an agent executes against real infrastructure). Both live in [`methodology.md`](methodology.md). The cadence below is about how *this repository* gets built — a separate concern that happens to share the word.

## Build cadence

Phased, each phase closing with a `CHANGELOG.md` entry and a version tag. The tags are the checkable evidence the cadence is real rather than aspirational.

| Phase | Scope | Status |
|---|---|---|
| **0 — Repo hygiene** | `LICENSE`, `.gitignore`, `CONTRIBUTING.md`, root `AGENTS.md` / `CLAUDE.md`, `docs/methodology.md` | Built → `v0.3.0` |
| **1 — Discovery layer** | `discovery/` — needs, hardware envelope, AI tooling, each criteria-based rather than brand-based | Built → `v0.3.0` |
| **2 — Foundation blocks** | `blocks/foundation/host-platform/` (isolation/storage/simplicity/raw-control axes) and `blocks/foundation/network/` (topology, addressing) — both consuming discovery's output | Built → `v0.3.0` |
| **3 — Flagship domain block** | `blocks/domains/proxmox-ai-stack/` — Proxmox + GPU passthrough + AI services, `requires: [foundation/host-platform, foundation/network]` | Built, **unverified** → `v0.3.0` |
| **4 — Dogfood** | Run discovery → host-platform → flagship end to end in a live agent session against real Proxmox hardware. Fix what breaks | **Not started — the main open gap** |
| **5 — Block schema for future categories** | `docs/block-schema.md` formalizing CEP + `requires:` + manifest fields, so media / home-automation / personal-cloud blocks can be added without inventing structure | Built → `v0.3.0` |
| **6 — Composition examples** | `examples/` showing multiple blocks combined, demonstrating how `requires:` and the manifest compose | Not started |
| **7 — Community layer** | `.github/ISSUE_TEMPLATE`, `.github/PULL_REQUEST_TEMPLATE.md` with the validation attestation | Built → `v0.3.0` |

Phases 5 and 7 landed early alongside the blocks they describe rather than strictly in order. That's fine — the ordering is a dependency guide, not a schedule.

**Two things landed after `v0.3.0` that were not in the original phase list**, both because closing gap #3 turned out to require them. **`start-here/`** — the phases above built the content an agent works *through* and never built the thing that tells an agent how to move between them. **`blocks/foundation/hardware-bringup/`** — the cold walkthrough found that nothing owned the stretch between deciding a platform and having a machine to run it on. Both slot before Phase 4 in dependency order (a dogfood session has to start somewhere, and on something), and neither is its own phase, since both are infrastructure for the existing ones rather than new scope.

**Why one tag and not three.** This table originally promised a tag per phase — `v0.1.0` at discovery, `v0.2.0` at the foundation blocks, `v0.3.0` at the flagship. The git history can't carry that: phases 0–3, 5, and 7 landed inside two commits on a single branch, so no commit boundary matches a phase boundary. Placing three tags would mean picking arbitrary commits and calling them releases, which is exactly the kind of claim-without-evidence this page exists to avoid. They close together under `v0.3.0` instead. Future phases get their own tags, since they'll land as their own work.

**Deliberately not built yet:** media, home automation, and personal-cloud/backup domain blocks, and everything in the `core-services` tier (reverse proxy, DNS, auth/SSO — see `docs/block-schema.md`). `blocks/foundation/host-platform/` was broadened (2026-08-06) to name four decision axes — isolation, storage, simplicity, raw-control — but that's decision-layer text, not new infrastructure; it doesn't create new folders. Candidate future *domain* blocks that would build on the storage and simplicity axes specifically: a TrueNAS SCALE storage/media block, an OpenMediaVault lightweight-NAS block, a CasaOS simple-dashboard block. Candidate future *core-services* blocks: `reverse-proxy`, `dns`, `auth-sso` — every domain block added after the flagship will want at least the first two, so these move up in priority once a second domain block is proposed. Named here so the intent is tracked; folders stay uncreated until someone actually writes one. A directory of empty stubs would make the repo look broader than it is, which is the opposite of useful.

## Versioning

Pre-1.0, `0.x.y`, and the `0.` is meaningful rather than modest:

- **`0.x`** — the structure is real and usable, but no block has been validated end-to-end against real hardware. Interfaces (the CEP shape, `requires:`, the manifest schema) may still change.
- **`1.0`** would mean: at least one complete path — discovery → all three foundation blocks → a domain block — has been dogfooded live against real hardware, the task-completion test below passes, and no block ships `unverified` without saying so prominently.

Until then, treat everything here as a well-structured draft that hasn't met reality yet.

## The three metrics

Only three, tracked deliberately. Stars and forks are excluded — they measure attention, not whether the thing works.

**1. CEP completeness** — how many blocks have a complete Checklist + Example + Placeholders triple.

| Block | Checklist | Example | Placeholders | Complete |
|---|---|---|---|---|
| `discovery/needs.md` | yes | yes | yes (n/a, stated) | yes |
| `discovery/ai-tooling.md` | yes | yes | yes (n/a, stated) | yes |
| `discovery/hardware-envelope.md` | yes | yes | yes (n/a, stated) | yes |
| `blocks/foundation/host-platform/` | yes | yes | yes | yes |
| `blocks/foundation/hardware-bringup/` | yes | yes | yes | yes |
| `blocks/foundation/network/` | yes | yes | yes | yes |
| `blocks/domains/proxmox-ai-stack/` | yes | yes | yes | yes |

**7 / 7 structurally complete.** Note what this metric does and doesn't say: it counts whether the three parts exist and are genuinely filled, not whether their contents are correct. Metric 3 is what tests correctness.

`start-here/` is deliberately not a row and never will be. It isn't a block — there's nothing in it to adapt, so a CEP triple would be three empty ceremonies. Same reason `discovery/README.md` isn't a row while the three discovery topics are. The denominator counts blocks and discovery topics; adding non-block folders to it would inflate the number without measuring anything.

**2. Oldest `last-verified` date** — the staleness signal across all blocks.

Currently **n/a — no block has ever been verified.** All four blocks carry `last-verified: unverified`. This metric only starts producing a number after Phase 4, and that's precisely why it's worth tracking: an empty value here is a louder signal than an old date would be.

**3. Task-completion test** — can an agent, given *only* one block plus the manifest schema, complete a named realistic task without asking for out-of-band context? Run manually each release as a pass/fail gate.

Named task for the flagship: *"Create a GPU-passthrough VM on the existing Proxmox node and deploy a local LLM with a chat interface, touching nothing else."* Currently **untested against real hardware.** A static review in August 2026 found four missing facts that would have blocked an agent (host access method, single-GPU console lockout, q35/OVMF requirement, in-VM GPU driver and container runtime); those have been added to the checklist, but static review is not the test — Phase 4 is.

## Open gaps

The running list. Items get struck through and dated when closed, not deleted.

**Blocking 1.0:**

1. **Dogfood `blocks/domains/proxmox-ai-stack/` against real Proxmox hardware.** This is the single biggest gap and the reason the flagship reads `unverified`. Closing it means: a live agent session creating a real VM with real GPU passthrough on real hardware, following only what's in the block; every command in `AGENTS.md.example` confirmed or corrected; `last-verified` / `verified-against` frontmatter replaced with real values; the flagship's own `README.md` and the root README updated to match. Needs hardware and an operator — no synthetic substitute exists, which is the accepted cost of the bring-your-own-infra path.

   *Named suspects to check first, so "unverified" is a prediction rather than a disclaimer:* the example sets the IOMMU kernel argument via `/etc/kernel/cmdline` + `proxmox-boot-tool refresh`, which is the systemd-boot path used on ZFS-root installs — a GRUB-booted node needs `/etc/default/grub` + `update-grub` instead, and the example currently doesn't branch on that. Also unconfirmed: whether the vendor driver install inside the VM needs the host to hide the hypervisor from the guest, and whether the stated `q35` + OVMF combination is sufficient on consumer motherboards with less clean IOMMU grouping than the example assumes.
2. **Walk all three foundation blocks — `host-platform/`, `hardware-bringup/`, and `network/` — with a real person.** `host-platform/` and `network/` are decision layers and lower risk than the flagship, but all three are equally unverified and shouldn't quietly ride along on the flagship's validation. **`hardware-bringup/` is the one to walk first and the hardest to fake**: its checkpoints have never met a real parts order, a real assembly, or a real first connection, and unlike the other two its failure modes cost money rather than time. Its protocol was designed from a walkthrough that *found* the gap, not from a completed build. `network/` in particular is untested against a real VLAN-capable switch/router — the worked example assumes 802.1Q trunking support that's never been confirmed against real consumer hardware.
3. **Cold-walkthrough `discovery/`.** **Run once, 2026-08-06 — findings recorded below, gap stays open.** The run produced real defects rather than a clean pass, which is the useful outcome, but it did *not* produce a self-consistent decision set end to end: it stopped before the envelope was final, and #4 and #5 below mean the journey structurally cannot complete yet. Re-run after those close. The persona used: an enthusiast with a laptop and an underpowered Pi, $2–3k, storage-first, wanting personal cloud → media → AI in that order.

**From the 2026-08-06 cold walkthrough:**

4. **Three of the four discovery categories still have no block.** `discovery/needs.md` offers AI, media, home automation, and personal cloud; only AI has a block. In the 2026-08-06 walkthrough the person's top *two* priorities were uncovered, so discovery produced a decision set the repo could not act on. **Half-closed 2026-08-06:** `start-here/TRAVERSAL.md` now has defined behavior when `priority` names a category with no block — say so plainly, offer the covered ones, point at the block-gap template, and never silently promote their second choice. That stops the agent improvising, but it doesn't build anything. **Still open:** `personal-cloud`, `media`, and `home-automation` domain blocks. Sequencing note: #7 below now gates these — four domain blocks without a shared reverse proxy and DNS will each reinvent them and drift apart immediately.
5. **Minor — the methodology agreement is presented before comfort level is known.** `TRAVERSAL.md` puts it "before anything else"; the Discovery & Advisory Cadence says calibrate to comfort level immediately, and `needs.md` calls that "the very first question." So the one message guaranteed to be mis-pitched is the first one. Low cost, real ordering conflict.

**Known content gaps:**

6. **No `examples/` directory (Phase 6).** Nothing yet demonstrates two blocks composing, which is the main thing `requires:` exists for. This gets more valuable once a second domain block exists.
7. **`core-services` tier is named but empty — and #4 makes this urgent.** Every domain block after the flagship will want a reverse proxy and DNS at minimum. That was deferrable while one domain block existed; committing to three more (`personal-cloud`, `media`, `home-automation`) means `reverse-proxy` and `dns` now come first or alongside them, or each of the four reinvents its own reverse-proxy instructions and they drift apart immediately.

**Closed:**

- ~~The bootstrap gap: nothing covered "decided" → "machine exists and is reachable." `host-platform` said it "does not install anything by itself"; the flagship assumed an already-installed host. Buying, assembling, installing, networking, and enabling remote access was owned by nothing and stepped straight over by `TRAVERSAL.md`.~~ Fixed 2026-08-07 — `blocks/foundation/hardware-bringup/`, deliberately thin: it owns the protocol (three checkpoints, verification questions, the resume contract, universal safety notes, and a standing rule to point at the manuals) and never the content, because assembly instructions rot, differ per component, and duplicate the box manual. Stated in the block itself that the value is the gates rather than the guidance, so nobody later fills it with a build tutorial.
- ~~No `assumes:` field — nothing declared what the *human* had to be able to do, so difficulty was discovered mid-block instead of announced at entry.~~ Fixed 2026-08-07 — `assumes:` sits beside `requires:` with four capability tags, **every one carrying a fallback** (a bare assumption is a bug). Scoped to blocks where the human does something; discovery declares none. `TRAVERSAL.md` step 4 checks it against `comfort_level` at block entry and states any mismatch with the fallback attached — preparation, never permission.
- ~~`decisions:` values had no vocabulary, while `host-platform/CHECKLIST.md` already branched on `comfort_level` twice. The walkthrough had to invent `comfort_level`, `budget_band`, `wants`, and `constraints` in formats that didn't match the documented examples.~~ Fixed 2026-08-07 — closed sets for `comfort_level` (four values), `wants`, and `priority` in `manifest-schema.md`; every consumer updated to name real values; `budget_band` and `constraints` left deliberately open, with the reason recorded.
- ~~No `awaiting-human` state. `in-progress` on a block stalled three weeks told the next session work was underway, which is the opposite of true.~~ Fixed 2026-08-07 — status added plus an `awaiting:` record whose `agent-resumes-by` field is the next session's first action. `TRAVERSAL.md` defines the behavior: report position and stop, never try to finish it.
- ~~`TRAVERSAL.md` never said where the user's own repo is — it told an agent to look for `.homelab-state.yml` somewhere a first-time reader doesn't have.~~ Fixed 2026-08-07 — step 1 now handles the no-repo case explicitly: ask once, offer a default, never let it block.
- ~~"Where the agent runs" vs "what the agent operates on" was never distinguished. The walkthrough persona concluded their laptop would have to *be* the server.~~ Fixed 2026-08-07 — `discovery/ai-tooling.md` now states plainly and unprompted that the agent runs on the person's everyday machine and reaches the headless server over the network.
- ~~The envelope was a dead end: `hardware-envelope.md` said it "gets handed to official vendor documentation" without saying who does the handing or how. The walkthrough persona asked "what would my options look like today?" twice and got answers from the agent's general knowledge rather than anything the repo defined.~~ Fixed 2026-08-07 — `hardware-bringup`'s checkpoint 1 is that step, with a line-by-line validation gate against `hardware_envelope` before money moves. The repo still stores no picks.
- ~~`manifest-schema.md` contradicted itself on `wants` vs `blocks:` — the example showed `wants: [ai-stack, media]` alongside `media: excluded`.~~ Fixed 2026-08-07 — the two are defined as describing the same live intent, with the invariant stated: an `excluded` block must not appear in `wants`, and anything in `wants` must not be `excluded`.
- ~~No version tags in git — the build cadence said each phase closes with a tag, but the phase table was the only record, making it a claim rather than evidence.~~ Fixed 2026-08-06 — `v0.3.0` tagged at the first merge to `main`, closing phases 0–3, 5, and 7 together for the reason given under the phase table.
- ~~`requires:` was declared everywhere but resolvable nowhere. It appeared in four different shapes (tiered path, bare folder name, discovery-topic name, and a prose "none"), only two of which `block-schema.md` documented, and no file said how a tiered path maps to a flat `blocks:` status key — or that individual discovery topics have no status key at all, making `requires: [needs]` resolve to nothing.~~ Fixed 2026-08-06 — `start-here/TRAVERSAL.md` specifies all four shapes and both resolution paths; `block-schema.md` updated to match; `discovery/needs.md` normalized to `requires: none`.
- ~~An agent handed this repo had to infer the traversal order — discovery before foundation, both foundation blocks before any domain block, finish `in-progress` before starting downstream. Nothing stated it.~~ Fixed 2026-08-06 — `start-here/` added.
- ~~The worked example didn't survive its own pipeline: `discovery/hardware-envelope.md` left the GPU fork unresolved and preferred sub-15W idle, while `docs/manifest-schema.md` showed `gpu: discrete-required`, `vram_gb: 12`, and `idle_power_w: 35` for the same fictional persona. Running discovery as written could not produce the manifest example, breaking the "same fictional homelab" continuity the blocks claim.~~ Fixed 2026-08-06 — the envelope example now resolves both conflicts in front of the reader and lands on the manifest's values.
- ~~The hardware-envelope worked example never resolved discrete GPU vs. integrated, and paired a PCIe x16 slot with a sub-15W idle target and a fanless preference, which don't coexist in one machine.~~ Fixed 2026-08-06 — resolved to a discrete GPU with the noise and idle-power consequences accepted explicitly, and the class of error is now caught by the named consistency checks rather than left to reviewer attention.
- ~~`blocks/foundation/network/README.md` said its bridge mapping was read by `blocks/foundation/host-platform/` too, implying a dependency host-platform never declares and its checklist never uses.~~ Fixed 2026-08-06 — the sentence was wrong, not the dependency graph; only domain blocks read that field.
- ~~`docs/index.md` claimed named products were "isolated in one small file"; they appear in five.~~ Fixed 2026-08-06 — claim reworded to what's true (illustrations in decision-layer text only, never in executed instructions) rather than building a file to make the old sentence true.
- ~~Root `README.md` and `CHANGELOG.md` still said "both blocks" and "neither" after `blocks/foundation/network/` was added, undercounting the blocks that ship unverified.~~ Fixed 2026-08-06 — all three now counted.
- ~~Flagship `README.md` claimed it had been dogfooded against real hardware, contradicting its own `unverified` frontmatter.~~ Fixed 2026-08-06.
- ~~`blocks/host-platform/` carried no validation status at all.~~ Fixed 2026-08-06 — now marked unverified in both its README and its example's frontmatter.
- ~~Both `AGENTS.md.example` files were mostly `<<PLACEHOLDER>>` tokens rather than filled examples, contradicting `block-schema.md` and the repo's own central argument.~~ Fixed 2026-08-06 — both rewritten with realistic fake values inline; `PLACEHOLDERS.md` demoted to a find-and-replace map.
- ~~`discovery/` had no `README.md`, despite being the root README's "start here" link and despite the repo-wide rule requiring a human entry point in every folder.~~ Fixed 2026-08-06.
- ~~`docs/manifest-schema.md` documented four `decisions:` keys while discovery instructed agents to write ten others.~~ Fixed 2026-08-06.
- ~~Several files referenced a "build cadence" and "planning history" that existed only in a private plan file.~~ Fixed 2026-08-06 — this page is what they now point at.
- ~~`blocks/domains/proxmox-ai-stack/CHECKLIST.md` asked "which VLAN/bridge" as if it were that block's own decision, with no block actually owning network topology.~~ Fixed 2026-08-06 — `blocks/foundation/network/` now owns it; `blocks/` reorganized into `foundation/` / `core-services/` (named, not yet built) / `domains/` tiers; `requires:` now uses tiered paths throughout.

## Filing a gap

Found something this list is missing? That's the most useful contribution there is — open an issue using the block-gap template. A checklist that turned out to be missing something your environment needed is exactly the signal this repo is built to collect.
