# Changelog

Format: one entry per phase/version tag, per the build cadence in [`docs/roadmap.md`](docs/roadmap.md).

Versioning is pre-1.0 `0.x.y`. `1.0` requires at least one path dogfooded end-to-end against real hardware — see the versioning section in the roadmap for what that means concretely.

## [Unreleased]

### Added (cold-walkthrough remediation, 2026-08-07)
- **`blocks/foundation/hardware-bringup/`** — the block nothing owned: buying parts, assembling, installing the platform, getting it on the network, enabling remote access. Deliberately thin. It owns the *protocol* — three checkpoints (before money moves, after assembly, first connection), the verification questions at each, the resume contract, universal safety notes, and a standing rule to point at the manuals rather than invent a spec — and never the content, because assembly instructions rot, differ per component, and duplicate the box manual. The block says so itself, so nobody later mistakes thinness for incompleteness. Skippable via `excluded` for anyone who already owns a running server.
- **`assumes:`** — a field beside `requires:` declaring what the *human* must be able to do (`physical-assembly`, `os-install`, `bios-firmware`, `network-hardware`). **Every tag ships with a fallback**; a bare assumption is a bug. Announced at block entry with the fallback attached, never discovered mid-block — it exists to prepare someone, never to disqualify them.
- **`awaiting-human` status plus an `awaiting:` record.** `in-progress` on a block stalled three weeks tells the next session work is underway, which is the opposite of true. `agent-resumes-by` is what a fresh session reads to know its first action without re-interviewing anyone.
- **Closed vocabularies** for `comfort_level` (four values), `wants`, and `priority`, with every consumer updated to name real values. `budget_band` and `constraints` stay deliberately open, with the reason recorded, since nothing branches on them.

### Fixed (cold-walkthrough remediation, 2026-08-07)
- `start-here/TRAVERSAL.md` gained defined behavior for four cases it previously walked straight past: no user repo exists yet, a block sitting at `awaiting-human` (report position and stop — do not try to finish it), `priority` naming a category with no block (say so; never silently promote their second choice), and `excluded` satisfying a `requires:` entry (with the caveat that you verify the underlying fact, not the status).
- `discovery/ai-tooling.md` now states plainly and unprompted that the agent runs on the person's everyday machine and reaches the headless server over the network. The walkthrough persona had concluded their laptop would have to *be* the server.
- `docs/manifest-schema.md` no longer contradicts itself on `wants` versus `blocks:` — the two describe the same live intent, and the invariant is stated: an `excluded` block must not appear in `wants`, and nothing in `wants` may be `excluded`.
- The foundation tier now has a stated order (`host-platform` → `hardware-bringup` → `network`) and a reason for it: `network/` asks which physical NICs the host has, which nobody can answer about a machine that doesn't exist. Domain blocks require all three.

### Added
- `start-here/` — the entry point an agent is handed first. `TRAVERSAL.md` specifies how to read `.homelab-state.yml`, resolve `requires:`, pick the next block, and hand off to the right cadence; `README.md` is the human counterpart. It sits outside the tier system alongside `discovery/` and carries no CEP triple, because there's nothing in it to adapt. Deliberately not named `AGENTS.md.example` — that suffix means "filled template, find-and-replace it," and this file is followed verbatim.
- `discovery/hardware-envelope.md` gained a **Consistency checks** section — six named conflicts an envelope can contain while every individual line looks fine (`ai-stack` wanted with no VRAM figure, fanless alongside a discrete GPU, low idle power alongside a discrete GPU, a VRAM target the budget can't reach, media with fixed storage, and a beginner comfort level facing GPU passthrough). Each is surfaced to the person rather than resolved silently.

### Fixed
- **`requires:` was declared everywhere but resolvable nowhere.** It appeared in four shapes — tiered path, bare folder name, discovery-topic name, and a prose `none — this is the starting point.` — of which `docs/block-schema.md` documented two. No file stated how a tiered path maps to a flat `blocks:` status key (last path segment), and `requires: [needs]` resolved to nothing at all, because `docs/manifest-schema.md` deliberately gives individual discovery topics no status entry. Both resolution paths are now specified in `start-here/TRAVERSAL.md`, discovery topics resolve by the `decisions:` keys they produce, and `discovery/needs.md` is normalized to `requires: none`.
- **The worked example didn't survive its own pipeline.** `discovery/hardware-envelope.md` left the GPU fork open ("PCIe x16 slot **or** built-in GPU… flag as follow-up") and preferred sub-15W idle, while `docs/manifest-schema.md` showed `gpu: discrete-required`, `vram_gb: 12`, and `idle_power_w: 35` for the same fictional persona. Running discovery exactly as written could not produce the manifest example. The envelope example now resolves both conflicts in front of the reader — showing the agent walking the person through each tradeoff — and lands on the manifest's values, restoring the continuity the blocks claim.
- The same example's internal contradiction (a PCIe x16 slot alongside a sub-15W idle target and a fanless preference) is resolved, and that class of error is now caught by the named consistency checks rather than left to reviewer attention. Closes roadmap gap #4.
- **`discovery/ai-tooling.md` was the one discovery topic that resolved to nothing.** It stated the chosen tooling class "doesn't need to be written into `.homelab-state.yml`," which left `blocks: discovery` able to flip to `done` without the topic having been worked through at all, and left an advisory-only setup with no recorded reason for stopping at the end of discovery. It now writes `decisions.agent_capability` (`shell-capable` / `advisory-only`), documented in `docs/manifest-schema.md` and read by `start-here/TRAVERSAL.md` to decide whether execution can proceed. An agent knows its own capability class, but recording it is what lets a later session understand why work stopped.

## [0.3.0] — 2026-08-06

First tagged release. Phases 0–3, 5, and 7 of the build cadence landed together on one branch rather than at separate commits, so they close under a single tag — see the phase table in [`docs/roadmap.md`](docs/roadmap.md). This is a `0.x` release in the sense the versioning policy defines: the structure is real and usable, but all three blocks ship `unverified` and the open gaps are tracked in the roadmap.

### Added
- Repo hygiene: `LICENSE` (MIT), `.gitignore`, `CONTRIBUTING.md`, root `AGENTS.md` / `CLAUDE.md`.
- `docs/methodology.md` — CEP method, Discovery & Advisory Cadence, Agent Operating Cadence, validation rules, link-vetting rule.
- `docs/index.md`, `docs/block-schema.md`, `docs/manifest-schema.md`.
- `docs/roadmap.md` — build cadence (phases 0–7), pre-1.0 versioning policy, the three tracking metrics, and the running list of open gaps.
- `discovery/` — needs, hardware-envelope, and AI-tooling discovery as CEP triples, plus a `README.md` human entry point.
- `blocks/foundation/host-platform/` — foundation block (decision layer: isolation-, storage-, simplicity-, or raw-control-first).
- `blocks/foundation/network/` — foundation block (topology, addressing, bridge mapping).
- `blocks/domains/proxmox-ai-stack/` — first domain block, currently unverified.
- `.github/` issue and PR templates.

### Fixed (review pass, 2026-08-06)
- Flagship `README.md` claimed it had been dogfooded against real hardware while its own frontmatter read `last-verified: unverified`. Now honestly marked unverified in both places, and in the root `README.md`.
- `blocks/host-platform/` carried no validation status at all, in violation of the rule in `docs/block-schema.md`. Now marked unverified.
- Both `AGENTS.md.example` files were largely `<<PLACEHOLDER>>` tokens rather than filled examples — contradicting `docs/block-schema.md`, `docs/methodology.md`, and the repo's own central argument that blanks are useless to an agent. Both rewritten with realistic fake values inline; each `PLACEHOLDERS.md` is now a find-and-replace map.
- `blocks/proxmox-ai-stack/CHECKLIST.md` was missing four facts an agent would have been blocked on: how it reaches the host, the single-GPU console-lockout risk, the `q35` + OVMF requirement, and in-VM GPU driver plus container-runtime setup.
- `docs/manifest-schema.md` documented four `decisions:` keys while `discovery/` instructed agents to write ten others verbatim.
- References to a "build cadence" and "planning history" pointed at a plan file that doesn't exist in the repo. They now resolve to `docs/roadmap.md`.

### Added (safety + scope pass, 2026-08-06)
- `DISCLAIMER.md` — real-infrastructure risk (data loss, downtime, hardware misconfiguration) and third-party script execution risk, separate from `LICENSE`'s legal terms.
- Agent Operating Cadence step 0 — a standing methodology agreement, recorded once in `.homelab-state.yml`/`HOMELAB.md`, checked before any execution regardless of whether the surrounding harness auto-approves actions.
- Agent Operating Cadence step 3 extended — an agent must propose the safer path (backup/snapshot, sandbox, or test-first) alongside any state-changing action, every time, not just once per session.
- `blocks/foundation/host-platform/` broadened from a single isolation-vs-not fork to four decision axes (isolation, storage/ZFS, simplicity, raw-control), each with illustrative-only platform examples and no ranking — closes a real gap where the block funneled every path toward Proxmox regardless of what the person actually wanted.

### Changed (tiering pass, 2026-08-06)
- `blocks/` reorganized into three tiers: `foundation/` (decisions nearly everything depends on), `core-services/` (shared services — named in `docs/block-schema.md`, not yet built), `domains/` (end-user-facing workloads). Moved via `git mv` to preserve history: `blocks/host-platform/` → `blocks/foundation/host-platform/`, `blocks/proxmox-ai-stack/` → `blocks/domains/proxmox-ai-stack/`.
- Added `blocks/foundation/network/` as a new CEP triple — topology, addressing, and bridge mapping. Closes a real bug: `blocks/domains/proxmox-ai-stack/CHECKLIST.md` previously asked "which VLAN/bridge" as if it were that block's own decision, with no block actually owning network topology.
- `requires:` fields across all blocks now use tiered paths (`foundation/host-platform`, `foundation/network`) instead of bare names. `.homelab-state.yml`'s `blocks:` keys deliberately stay flat — see `docs/manifest-schema.md` for why the two are different shapes.
- All relative links inside moved blocks' `AGENTS.md.example` files corrected for the new directory depth (`../../docs/` → `../../../docs/`).
- `docs/block-schema.md`, `docs/roadmap.md`, `README.md`, `CONTRIBUTING.md`, `discovery/README.md`, and both foundation blocks' own cross-references updated to match.

### Fixed (release-prep pass, 2026-08-06)
- `README.md` and this file still said "both blocks" and "neither" after `blocks/foundation/network/` was added in the tiering pass, undercounting the blocks that ship unverified. All three are now counted. `docs/roadmap.md`'s "both foundation blocks" phrasings were left alone — there really are exactly two of those.
- `docs/roadmap.md`'s phase table promised a tag per phase (`v0.1.0` / `v0.2.0` / `v0.3.0`), which the git history can't support: phases 0–3, 5, and 7 landed inside two commits on one branch. The table now records that they close together under `v0.3.0`, and says why.
- `docs/roadmap.md` open gap #6 ("No version tags in git") closed and moved to the Closed list.
- `blocks/foundation/network/README.md` claimed its bridge mapping was read by `blocks/foundation/host-platform/` as well as by domain blocks — an undeclared dependency, the bug class `docs/block-schema.md` names explicitly. Three sources say otherwise: `network/CHECKLIST.md` says only domain blocks read it, `host-platform/README.md` declares `requires: [discovery]`, and `host-platform/CHECKLIST.md` never mentions bridges or VLANs. The sentence was wrong; the dependency doesn't exist. Corrected.
- `docs/index.md` asserted that named products are "isolated in one small file" — they appear in five (`blocks/foundation/host-platform/` README, CHECKLIST, and PLACEHOLDERS, `blocks/foundation/network/README.md`, `docs/roadmap.md`). Reworded to what's actually true and checkable: named products appear only in decision-layer text, marked as illustrations, never in executed instructions. No new file was created to satisfy the old sentence — that would have added structure nobody needs.
- `docs/index.md` described the downstream path as "host platform, then domain blocks," omitting `blocks/foundation/network/` after it was added in the tiering pass.
