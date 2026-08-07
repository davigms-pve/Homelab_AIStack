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

**`start-here/` was not in the original phase list.** It landed after `v0.3.0` because closing gap #3 turned out to require it: the phases above built the content an agent works *through*, and never built the thing that tells an agent how to move between them. It slots before Phase 4 in dependency order — a dogfood session has to start somewhere — but it isn't its own phase, since it's infrastructure for the existing ones rather than new scope.

**Why one tag and not three.** This table originally promised a tag per phase — `v0.1.0` at discovery, `v0.2.0` at the foundation blocks, `v0.3.0` at the flagship. The git history can't carry that: phases 0–3, 5, and 7 landed inside two commits on a single branch, so no commit boundary matches a phase boundary. Placing three tags would mean picking arbitrary commits and calling them releases, which is exactly the kind of claim-without-evidence this page exists to avoid. They close together under `v0.3.0` instead. Future phases get their own tags, since they'll land as their own work.

**Deliberately not built yet:** media, home automation, and personal-cloud/backup domain blocks, and everything in the `core-services` tier (reverse proxy, DNS, auth/SSO — see `docs/block-schema.md`). `blocks/foundation/host-platform/` was broadened (2026-08-06) to name four decision axes — isolation, storage, simplicity, raw-control — but that's decision-layer text, not new infrastructure; it doesn't create new folders. Candidate future *domain* blocks that would build on the storage and simplicity axes specifically: a TrueNAS SCALE storage/media block, an OpenMediaVault lightweight-NAS block, a CasaOS simple-dashboard block. Candidate future *core-services* blocks: `reverse-proxy`, `dns`, `auth-sso` — every domain block added after the flagship will want at least the first two, so these move up in priority once a second domain block is proposed. Named here so the intent is tracked; folders stay uncreated until someone actually writes one. A directory of empty stubs would make the repo look broader than it is, which is the opposite of useful.

## Versioning

Pre-1.0, `0.x.y`, and the `0.` is meaningful rather than modest:

- **`0.x`** — the structure is real and usable, but no block has been validated end-to-end against real hardware. Interfaces (the CEP shape, `requires:`, the manifest schema) may still change.
- **`1.0`** would mean: at least one complete path — discovery → both foundation blocks → a domain block — has been dogfooded live against real hardware, the task-completion test below passes, and no block ships `unverified` without saying so prominently.

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
| `blocks/foundation/network/` | yes | yes | yes | yes |
| `blocks/domains/proxmox-ai-stack/` | yes | yes | yes | yes |

**6 / 6 structurally complete.** Note what this metric does and doesn't say: it counts whether the three parts exist and are genuinely filled, not whether their contents are correct. Metric 3 is what tests correctness.

`start-here/` is deliberately not a row and never will be. It isn't a block — there's nothing in it to adapt, so a CEP triple would be three empty ceremonies. Same reason `discovery/README.md` isn't a row while the three discovery topics are. The denominator counts blocks and discovery topics; adding non-block folders to it would inflate the number without measuring anything.

**2. Oldest `last-verified` date** — the staleness signal across all blocks.

Currently **n/a — no block has ever been verified.** All three blocks carry `last-verified: unverified`. This metric only starts producing a number after Phase 4, and that's precisely why it's worth tracking: an empty value here is a louder signal than an old date would be.

**3. Task-completion test** — can an agent, given *only* one block plus the manifest schema, complete a named realistic task without asking for out-of-band context? Run manually each release as a pass/fail gate.

Named task for the flagship: *"Create a GPU-passthrough VM on the existing Proxmox node and deploy a local LLM with a chat interface, touching nothing else."* Currently **untested against real hardware.** A static review in August 2026 found four missing facts that would have blocked an agent (host access method, single-GPU console lockout, q35/OVMF requirement, in-VM GPU driver and container runtime); those have been added to the checklist, but static review is not the test — Phase 4 is.

## Open gaps

The running list. Items get struck through and dated when closed, not deleted.

**Blocking 1.0:**

1. **Dogfood `blocks/domains/proxmox-ai-stack/` against real Proxmox hardware.** This is the single biggest gap and the reason the flagship reads `unverified`. Closing it means: a live agent session creating a real VM with real GPU passthrough on real hardware, following only what's in the block; every command in `AGENTS.md.example` confirmed or corrected; `last-verified` / `verified-against` frontmatter replaced with real values; the flagship's own `README.md` and the root README updated to match. Needs hardware and an operator — no synthetic substitute exists, which is the accepted cost of the bring-your-own-infra path.

   *Named suspects to check first, so "unverified" is a prediction rather than a disclaimer:* the example sets the IOMMU kernel argument via `/etc/kernel/cmdline` + `proxmox-boot-tool refresh`, which is the systemd-boot path used on ZFS-root installs — a GRUB-booted node needs `/etc/default/grub` + `update-grub` instead, and the example currently doesn't branch on that. Also unconfirmed: whether the vendor driver install inside the VM needs the host to hide the hypervisor from the guest, and whether the stated `q35` + OVMF combination is sufficient on consumer motherboards with less clean IOMMU grouping than the example assumes.
2. **Walk both foundation blocks — `blocks/foundation/host-platform/` and `blocks/foundation/network/` — with a real person.** Lower risk than the flagship since both are decision layers, but both are equally unverified and shouldn't quietly ride along on the flagship's validation. `network/` in particular is untested against a real VLAN-capable switch/router — the worked example assumes 802.1Q trunking support that's never been confirmed against real consumer hardware.
3. **Cold-walkthrough `discovery/`.** **Run once, 2026-08-06 — findings recorded below, gap stays open.** The run produced real defects rather than a clean pass, which is the useful outcome, but it did *not* produce a self-consistent decision set end to end: it stopped before the envelope was final, and #4 and #5 below mean the journey structurally cannot complete yet. Re-run after those close. The persona used: an enthusiast with a laptop and an underpowered Pi, $2–3k, storage-first, wanting personal cloud → media → AI in that order.

**From the 2026-08-06 cold walkthrough:**

4. **Three of the four discovery categories have no block, and traversal has no branch for it.** `discovery/needs.md` offers AI, media, home automation, and personal cloud. Only AI has a block. `start-here/TRAVERSAL.md` step 3 says to pick a domain block "chosen by the user's `priority` field" and says nothing about the case where that field names something that doesn't exist. In the walkthrough the person's top *two* priorities were uncovered, so discovery produced a decision set the repo could not act on and the agent was left improvising at exactly the handoff the entrypoint exists to make reliable. This is distinct from the "deliberately not built yet" note above — that's about what to build next; this is traversal having no defined behavior when the graph runs out. **Agreed fix:** build `personal-cloud`, `media`, and `home-automation` domain blocks, and give `TRAVERSAL.md` a defined response for an uncovered priority in the meantime.
5. **The bootstrap gap: nothing covers "decided" → "machine exists and is reachable."** `blocks/foundation/host-platform/README.md` says it "does not install anything by itself"; the flagship assumes "an already-installed Proxmox host." Between them sits buying parts, assembling, installing an OS, networking it, and enabling remote access — unowned by any block, and stepped straight over by `TRAVERSAL.md`. Invisible to anyone who already owns a running server; for someone starting from a laptop it *is* the project. **Agreed fix:** `blocks/foundation/hardware-bringup/`, deliberately thin — it owns the protocol (three checkpoints, verification questions, resume contract, universal safety notes, and a standing rule to point at the manuals) and never the content. Assembly instructions rot, vary per component, and duplicate the box manual; the agent supplies current knowledge at runtime. The repo's value here is the verification gates, not the guidance — state that in the block so nobody later "helpfully" fills it with a tutorial.
6. **No `assumes:` field — nothing declares what the *human* must be able to do.** `requires:` covers block prerequisites; nothing covers human capability, so difficulty is discovered mid-block instead of announced at entry. **Agreed fix:** an `assumes:` field parallel to `requires:`, where **every assumption ships with a fallback** (`physical-assembly` → hand the envelope to a shop or buy pre-built to spec, which the spec-not-shopping-list rule already makes a first-class path). It must read as preparation, not permission — a bare assumption with no fallback is a bug. Scope it to blocks that require the human to *do* something; discovery topics declare nothing, to avoid the empty-ceremony problem.
7. **`decisions:` values have no vocabulary, and `comfort_level` has a live consumer.** `manifest-schema.md` enumerates status values for `blocks:` but no allowed values for any `decisions:` key. During the walkthrough `comfort_level`, `budget_band`, `wants`, and `constraints` all had to be invented, in formats that don't match the documented examples. This matters because `blocks/foundation/host-platform/CHECKLIST.md` already branches on `comfort_level` twice. **Agreed fix:** a closed, small `comfort_level` set, with that checklist updated to name real values. Keep the self-reported level and the per-task capability tags separate — a CLI-comfortable person may still not want to assemble hardware.
8. **No `awaiting-human` state.** `excluded`/`planned`/`in-progress`/`done` can't express "the agent is blocked pending physical work," and `in-progress` on a block stalled three weeks actively misleads the next session. Needs the status plus an `awaiting:` record (checkpoint, since, what the agent resumes by), and a defined behavior in `TRAVERSAL.md` step 3 — an `awaiting-human` block is not `in-progress` and should mean "report position and stop," not "finish it."
9. **`TRAVERSAL.md` never says where the user's own repo is.** It says to look for `.homelab-state.yml` "in the user's own repo (not this one)." A first-time reader has no such repo, and there's no instruction to ask where it should live or offer to create one.
10. **"Where the agent runs" vs "what the agent operates on" is never distinguished.** `discovery/ai-tooling.md` asks about the tool's form factor but never establishes that the agent runs on the person's daily machine and reaches the server over the network. The walkthrough persona inferred the opposite — that their laptop would have to be the server — and raised it as a worry. Cheap fix, real confusion.
11. **The envelope is a dead end for the person holding it.** `hardware-envelope.md` ends by saying the envelope "is what gets handed to official vendor documentation and reviews to find an actual match," without saying who does the handing or how. The walkthrough persona asked "what would my options look like today?" twice, and both answers came from the agent's general knowledge rather than anything the repo defines. Researching current parts against the envelope keeps the repo picks-free — the repo still stores nothing — but the step needs to exist. Naturally resolved by #5's checkpoint 1, which validates a candidate parts list against `hardware_envelope` before money moves.
12. **`manifest-schema.md` contradicts itself on `wants` vs `blocks:`.** The example shows `wants: [ai-stack, media]` alongside `media: excluded`. Nothing defines the relationship: if `wants` is a historical record, blocks reading it (`hardware-envelope.md` pulls "straight from the `wants` list") will size hardware for dropped workloads; if it's live, the example is wrong.
13. **Minor — the methodology agreement is presented before comfort level is known.** `TRAVERSAL.md` puts it "before anything else"; the Discovery & Advisory Cadence says calibrate to comfort level immediately, and `needs.md` calls that "the very first question." So the one message guaranteed to be mis-pitched is the first one. Low cost, real ordering conflict.

**Known content gaps:**

14. **No `examples/` directory (Phase 6).** Nothing yet demonstrates two blocks composing, which is the main thing `requires:` exists for. This gets more valuable once a second domain block exists.
15. **`core-services` tier is named but empty — and #4 makes this urgent.** Every domain block after the flagship will want a reverse proxy and DNS at minimum. That was deferrable while one domain block existed; committing to three more (`personal-cloud`, `media`, `home-automation`) means `reverse-proxy` and `dns` now come first or alongside them, or each of the four reinvents its own reverse-proxy instructions and they drift apart immediately.

**Closed:**

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
