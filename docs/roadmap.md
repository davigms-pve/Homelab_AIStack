# Roadmap, build cadence, and open gaps

**This repo is pre-1.0 and openly a work in progress.** No version has been declared working yet. This page is where that's tracked honestly — what's built, what's next, what's known to be incomplete, and what would have to be true to call a version done.

Two other cadences exist and are different from this one: the **Discovery & Advisory Cadence** (how an agent guides a person through decisions) and the **Agent Operating Cadence** (how an agent executes against real infrastructure). Both live in [`methodology.md`](methodology.md). The cadence below is about how *this repository* gets built — a separate concern that happens to share the word.

## Build cadence

Phased, each phase closing with a `CHANGELOG.md` entry and a version tag. The tags are the checkable evidence the cadence is real rather than aspirational.

| Phase | Scope | Status |
|---|---|---|
| **0 — Repo hygiene** | `LICENSE`, `.gitignore`, `CONTRIBUTING.md`, root `AGENTS.md` / `CLAUDE.md`, `docs/methodology.md` | Built, untagged |
| **1 — Discovery layer** | `discovery/` — needs, hardware envelope, AI tooling, each criteria-based rather than brand-based | Built, untagged → `v0.1.0` |
| **2 — Foundation block** | `blocks/host-platform/` — bare OS vs. Proxmox vs. other hypervisor, consuming discovery's output | Built, untagged → `v0.2.0` |
| **3 — Flagship domain block** | `blocks/proxmox-ai-stack/` — Proxmox + GPU passthrough + AI services, `requires: [host-platform]` | Built, **unverified** → `v0.3.0` |
| **4 — Dogfood** | Run discovery → host-platform → flagship end to end in a live agent session against real Proxmox hardware. Fix what breaks | **Not started — the main open gap** |
| **5 — Block schema for future categories** | `docs/block-schema.md` formalizing CEP + `requires:` + manifest fields, so media / home-automation / personal-cloud blocks can be added without inventing structure | Built, untagged |
| **6 — Composition examples** | `examples/` showing multiple blocks combined, demonstrating how `requires:` and the manifest compose | Not started |
| **7 — Community layer** | `.github/ISSUE_TEMPLATE`, `.github/PULL_REQUEST_TEMPLATE.md` with the validation attestation | Built, untagged |

Phases 5 and 7 landed early alongside the blocks they describe rather than strictly in order. That's fine — the ordering is a dependency guide, not a schedule.

**Deliberately not built yet:** media, home automation, and personal-cloud/backup blocks. They're named as the next domains, and their folders stay uncreated until someone actually writes one. A directory of empty stubs would make the repo look broader than it is, which is the opposite of useful.

## Versioning

Pre-1.0, `0.x.y`, and the `0.` is meaningful rather than modest:

- **`0.x`** — the structure is real and usable, but no block has been validated end-to-end against real hardware. Interfaces (the CEP shape, `requires:`, the manifest schema) may still change.
- **`1.0`** would mean: at least one complete path — discovery → host-platform → a domain block — has been dogfooded live against real hardware, the task-completion test below passes, and no block ships `unverified` without saying so prominently.

Until then, treat everything here as a well-structured draft that hasn't met reality yet.

## The three metrics

Only three, tracked deliberately. Stars and forks are excluded — they measure attention, not whether the thing works.

**1. CEP completeness** — how many blocks have a complete Checklist + Example + Placeholders triple.

| Block | Checklist | Example | Placeholders | Complete |
|---|---|---|---|---|
| `discovery/needs.md` | yes | yes | yes (n/a, stated) | yes |
| `discovery/ai-tooling.md` | yes | yes | yes (n/a, stated) | yes |
| `discovery/hardware-envelope.md` | yes | yes | yes (n/a, stated) | yes |
| `blocks/host-platform/` | yes | yes | yes | yes |
| `blocks/proxmox-ai-stack/` | yes | yes | yes | yes |

**5 / 5 structurally complete.** Note what this metric does and doesn't say: it counts whether the three parts exist and are genuinely filled, not whether their contents are correct. Metric 3 is what tests correctness.

**2. Oldest `last-verified` date** — the staleness signal across all blocks.

Currently **n/a — no block has ever been verified.** Both blocks carry `last-verified: unverified`. This metric only starts producing a number after Phase 4, and that's precisely why it's worth tracking: an empty value here is a louder signal than an old date would be.

**3. Task-completion test** — can an agent, given *only* one block plus the manifest schema, complete a named realistic task without asking for out-of-band context? Run manually each release as a pass/fail gate.

Named task for the flagship: *"Create a GPU-passthrough VM on the existing Proxmox node and deploy a local LLM with a chat interface, touching nothing else."* Currently **untested against real hardware.** A static review in August 2026 found four missing facts that would have blocked an agent (host access method, single-GPU console lockout, q35/OVMF requirement, in-VM GPU driver and container runtime); those have been added to the checklist, but static review is not the test — Phase 4 is.

## Open gaps

The running list. Items get struck through and dated when closed, not deleted.

**Blocking 1.0:**

1. **Dogfood `blocks/proxmox-ai-stack/` against real Proxmox hardware.** This is the single biggest gap and the reason the flagship reads `unverified`. Closing it means: a live agent session creating a real VM with real GPU passthrough on real hardware, following only what's in the block; every command in `AGENTS.md.example` confirmed or corrected; `last-verified` / `verified-against` frontmatter replaced with real values; both block `README.md`s and the root README updated to match. Needs hardware and an operator — no synthetic substitute exists, which is the accepted cost of the bring-your-own-infra path.

   *Named suspects to check first, so "unverified" is a prediction rather than a disclaimer:* the example sets the IOMMU kernel argument via `/etc/kernel/cmdline` + `proxmox-boot-tool refresh`, which is the systemd-boot path used on ZFS-root installs — a GRUB-booted node needs `/etc/default/grub` + `update-grub` instead, and the example currently doesn't branch on that. Also unconfirmed: whether the vendor driver install inside the VM needs the host to hide the hypervisor from the guest, and whether the stated `q35` + OVMF combination is sufficient on consumer motherboards with less clean IOMMU grouping than the example assumes.
2. **Walk `blocks/host-platform/` with a real person.** Lower risk than the flagship since it's a decision layer, but it's equally unverified and shouldn't quietly ride along on the flagship's validation.
3. **Cold-walkthrough `discovery/`.** Discovery can't be validated against hardware, so its test is different: run it fresh and confirm it produces a self-consistent decision set. It should be impossible to land on "no GPU needed" alongside "wants local LLM inference."

**Known content gaps:**

4. **The hardware-envelope worked example never resolves discrete GPU vs. integrated.** It says "one free PCIe x16 slot **or** built-in GPU" and defers VRAM as a follow-up — but that's the single fork that determines power draw, noise, and case size. The same example also pairs a PCIe x16 slot with a sub-15W idle target and a fanless preference, which don't coexist in one machine. A doc whose entire job is producing a spec envelope shouldn't leave its most consequential variable open.
5. **No `examples/` directory (Phase 6).** Nothing yet demonstrates two blocks composing, which is the main thing `requires:` exists for. This gets more valuable once a second domain block exists.
6. **No version tags in git.** The build cadence says each phase closes with a tag; the phase table above is currently the only record, which makes it a claim rather than evidence.

**Closed:**

- ~~Flagship `README.md` claimed it had been dogfooded against real hardware, contradicting its own `unverified` frontmatter.~~ Fixed 2026-08-06.
- ~~`blocks/host-platform/` carried no validation status at all.~~ Fixed 2026-08-06 — now marked unverified in both its README and its example's frontmatter.
- ~~Both `AGENTS.md.example` files were mostly `<<PLACEHOLDER>>` tokens rather than filled examples, contradicting `block-schema.md` and the repo's own central argument.~~ Fixed 2026-08-06 — both rewritten with realistic fake values inline; `PLACEHOLDERS.md` demoted to a find-and-replace map.
- ~~`discovery/` had no `README.md`, despite being the root README's "start here" link and despite the repo-wide rule requiring a human entry point in every folder.~~ Fixed 2026-08-06.
- ~~`docs/manifest-schema.md` documented four `decisions:` keys while discovery instructed agents to write ten others.~~ Fixed 2026-08-06.
- ~~Several files referenced a "build cadence" and "planning history" that existed only in a private plan file.~~ Fixed 2026-08-06 — this page is what they now point at.

## Filing a gap

Found something this list is missing? That's the most useful contribution there is — open an issue using the block-gap template. A checklist that turned out to be missing something your environment needed is exactly the signal this repo is built to collect.
