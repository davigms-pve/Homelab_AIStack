# Verification map — what each rung can reach

[`methodology.md`](methodology.md) defines the rungs `L0`–`L4`; this page does not restate them. It answers a different question, one the ladder alone hides: **for each thing this repo ships, which rungs can ever apply, and which individual items does each rung's evidence environment actually reach?**

It exists because the rungs do not stack neatly. A desk-check, a read-through against a running server, a nested-virtualization run, and a real-hardware run each reach a *different subset* of a block. Without writing that down, "get the flagship to `L3`" reads as one task, and it is really four environments with four different blind spots — which is how work stalls on the hard one while the cheap ones sit unstarted.

**Everything on this page is a prediction.** Nothing here moves any block up the ladder, changes any frontmatter, or counts as evidence. A cell saying a rung *can* reach an item is a claim about the environment, to be confirmed or corrected by the run that produces the real evidence artifact. *Last reviewed: 2026-10-08.*

## The four environments

| Short name | What it is | Rung it produces | What it structurally can't do |
|---|---|---|---|
| **Desk** | Reading the item against the vendor's current official docs | `L1` | Execute anything. Needs a vendor doc to exist for the item — decision heuristics and opinions have none. |
| **Private** | The maintainer's real, already-running Proxmox server (dual GPUs, local inference, containers, agent-operated — see [`field-evidence.md`](field-evidence.md)) | `L2` | Anything about buying, assembling, or installing: it was built before this repo existed. Anything about a different platform branch. Anything it can't safely be broken to test. Anything that *came from* it, where agreement is circular. |
| **Nested** | A Proxmox install inside a VM on an ordinary machine | `L3` with a non-empty `unreached:` | GPUs, IOMMU grouping, firmware settings, physical disks, real switch trunking. |
| **Real hardware** | A physical build, executed or reproduced start to finish | `L3` with `unreached: none`, or `L4` | Generalising: one machine proves one machine. See [What no rung gives you](#what-no-rung-gives-you). |

**The Private column was written without access to that deployment.** It is inferred from the description in `field-evidence.md` and nothing else. The maintainer can see the box and this map cannot — every Private cell is the first thing to correct, for example whether that host boots via GRUB or systemd-boot, whether its bridges are VLAN-aware, what storage backs it.

## What kind of thing each artifact is

| Artifact | Category | Why |
|---|---|---|
| `blocks/domains/proxmox-ai-stack/` | **Full ladder** | Command-bearing, hardware-dependent, destructive. Every rung applies, though no single environment reaches all of it. |
| `blocks/foundation/host-platform/` | **Partial** | A decision layer. `L1` applies only to its few checkable factual claims, `L3` has no obvious meaning (see [G16](roadmap.md)), and `L2` reaches one platform branch of five. |
| `blocks/foundation/network/` | **Partial** | A decision layer with one execution piece — Proxmox bridge creation. That piece climbs the ladder; the segmentation decisions do not. |
| `blocks/foundation/hardware-bringup/` | **Partial, and unusually so** | Deliberately thin: it points at manuals instead of containing procedure, so there is little for `L1` to read. `L2` is impossible. Its meaningful rungs are the top ones, and they need a real purchase. |
| `blocks/foundation/agent-operations/` | **Poor fit** | No vendor for `L1` to read against; its real test is adoption over months, which no rung describes. Tracked as [G15](roadmap.md) rather than patched here. |
| `discovery/` (three topics) and `start-here/` | **Off the ladder** | No commands to be wrong about. [`methodology.md`](methodology.md) already assigns them the guidance-quality axis, with a transcript as the evidence artifact. This page does not invent a rung for them. |

Not artifacts but worth saying: `docs/` is specification, not instruction — its correctness is whether the things built on it hold together, which the walkthroughs and CI exercise. And `.github/scripts/validate-blocks.sh` is the one thing in this repo that is fully executable and testable end to end; it is also what every claim on the ladder leans on.

## Reachability, item by item

`yes` = the environment can produce evidence for the item. `part` = it can produce some of what's needed, and the note says which part. `no` = structurally cannot. *Real hw* means `L3` bare metal or `L4`; they reach the same items and differ in who ran it.

### `proxmox-ai-stack` — the full ladder

Items follow [`CHECKLIST.md`](../blocks/domains/proxmox-ai-stack/CHECKLIST.md).

| Item | Desk | Private | Nested | Real hw | Note |
|---|---|---|---|---|---|
| How the agent reaches the host (SSH / `pvesh` / API token) | yes | yes | yes | yes | |
| Existing VM/LXC IDs, storage pool (`qm list`, `pvesm status`) | yes | yes | yes | yes | |
| GPU PCI address (`lspci -nn \| grep -i vga`) | part | yes | no | yes | Desk can check the command, not what a real card reports. Nested shows virtual devices only. |
| Single-GPU console lockout | part | part | no | part | The *consequence* is the point and the only safe way to see it is a single-GPU machine you're willing to lock yourself out of. If, as is likely, Private keeps one card for the host console, it can't show this. |
| IOMMU group check | part | yes | no | yes | Grouping is a property of the motherboard. One machine proves one grouping. |
| Host driver blacklist / `vfio-pci` binding | part | yes | no | yes | |
| Kernel IOMMU argument — `/etc/kernel/cmdline` vs GRUB fork | yes | part | part | yes | Desk answers both branches from Proxmox's own docs. Private and Nested each exercise only the bootloader they happened to use, and can look like coverage while leaving the other untested ([G1](roadmap.md), [G12](roadmap.md)). |
| IOMMU toggle in firmware (VT-d / AMD-Vi) | part | part | no | yes | A human in front of a BIOS screen; no way to run it remotely. Private can show only that it's already on. |
| Bridge / VLAN attachment, static IP or reservation | yes | yes | yes | yes | Real-switch trunking behaviour is separate — see `network/` below. |
| VM creation: `q35` + OVMF + EFI disk (`qm create`) | yes | yes | yes | yes | Syntax and the boot path are fully reachable in Nested. |
| Resource sizing, OS choice | no | part | yes | yes | A traceable-to-envelope decision, not a vendor fact. Evidence is that the run worked. |
| Never-touch list / blast radius | no | part | yes | yes | Reachable in Nested by planting a decoy VM and checking it survives. Private is a machine in use and shouldn't be used to test a destructive guard. |
| Guest GPU driver (`nvidia-smi` inside the VM) | yes | yes | no | yes | Needs a GPU in the guest. |
| Container GPU runtime (`--gpus all`) | yes | yes | part | yes | Nested can run the toolkit install steps but cannot show a GPU appearing. |
| LLM runtime and chat interface install | yes | yes | yes | yes | Nested runs it CPU-only, which is real execution of the install path. |
| Model size vs VRAM, and the claimed CPU-fallback behaviour | part | yes | no | yes | Runtime-specific behaviour, not vendor-documented. Empirical or nothing. |
| Ports exposed, internal-only vs reachable | part | yes | yes | yes | |
| Operational gotchas — digest pinning, `docker inspect` capture, `$$` escaping | yes | **circular** | yes | yes | These *came from* the Private deployment, so its agreement is worth nothing. Docker's docs and a Nested run are the real evidence. |
| Record GPU idle / load power draw | no | part | no | yes | Needs a power meter on a real build. |

**Done-when artifacts** (the five live checks the block ends on):

| Done-when | Desk | Private | Nested | Real hw |
|---|---|---|---|---|
| `nvidia-smi` inside the VM reports the card | no | yes | no | yes |
| A vendor image with `--gpus all` prints the card | no | yes | no | yes |
| Inference returns a completion **and** GPU utilization is non-zero | no | yes | part | yes |
| Chat interface loads from another machine and answers a prompt | no | yes | yes | yes |
| Every previously-running VM still running | no | part | yes | yes |

**Predicted `unreached:` for a Nested pass** (the G12 run): GPU discovery on a real device; single-GPU lockout; IOMMU grouping; host driver blacklisting and `vfio-pci` binding; the firmware IOMMU toggle and the *effect* of the kernel argument; guest GPU driver; container GPU visibility; the GPU-utilization half of the inference check; model-vs-VRAM fallback; power measurement; and whichever bootloader branch the install didn't use. That is two of the five done-when checks outright, half of a third, and the entire passthrough section — which is exactly the residue the block exists to get right, and the reason Nested alone cannot buy `1.0`.

### `network`

| Item | Desk | Private | Nested | Real hw | Note |
|---|---|---|---|---|---|
| Segmented or flat; segment count and purpose | no | no | no | no | Guidance, not fact. Guidance-quality axis only. |
| Subnet ranges that don't collide | no | no | no | no | Depends on the person's existing network; no environment but theirs. |
| Router/switch supports 802.1Q | part | no | no | part | Vendor- and model-specific. A general block can never cover this; the best case is that it asks the right question. |
| Which physical NIC carries the trunk | no | no | no | yes | |
| Bridge-to-VLAN mapping on Proxmox (the one execution piece) | yes | part | yes | yes | Private only if its bridges are VLAN-aware — unknown. Nested covers the host side fully. |
| Real switch trunking to a VLAN-aware bridge | no | part | no | yes | Needs a managed switch. |
| Static reservations vs DHCP reservations | part | part | no | part | Router-specific. Never fully reachable. |
| Internal DNS flag (decision only) | no | no | no | no | |

### `host-platform`

| Item | Desk | Private | Nested | Real hw | Note |
|---|---|---|---|---|---|
| The five axis questions and their weighing | no | no | no | no | Opinion with reasoning; no vendor, no execution. Guidance-quality axis. |
| Checkable factual claims (VM snapshots, passthrough needing IOMMU, etc.) | yes | yes | part | part | A short list. These are the only `L1` surface. |
| Resulting choice among `bare-docker`, `proxmox`, `truenas-scale`, `openmediavault`, `casaos` | no | part | no | part | Private is one data point on one branch — Proxmox. The other four branches have no environment here. |

### `hardware-bringup`

| Item | Desk | Private | Nested | Real hw | Note |
|---|---|---|---|---|---|
| Checkpoint 1: line-by-line parts vs `hardware_envelope` | part | no | no | yes | Desk can verify claims against a specific part's spec sheet, but the block deliberately names no parts. |
| Drive bays, connectors, PSU headroom, PCIe slot clearance | no | no | no | yes | Physical. |
| Checkpoint 2: power-on, drives listed, memory seen, boot media | no | no | no | yes | Physical. |
| Universal safety notes | part | no | no | no | General knowledge, checkable against manuals only. |
| Checkpoint 3: install, connect, read actual state, compare to the parts list | no | part | part | yes | The "connect and read state" step is Cadence step 1 and runs against any machine, including a Nested VM — but it can't show a real build's drift. |
| The `awaiting-human` / `awaiting:` resume contract across a real gap in time | no | no | no | yes | A real purchase leaves the session for days. A synthetic test can check the *shape* of the record; only a real wait shows whether a fresh session picks up correctly. |

The first physical rung that means anything for this block is `L4` or a real-hardware `L3`, and both need someone to buy parts. Its useful earlier evidence is a cold-reader transcript on the guidance axis.

### `agent-operations`

Mapped differently, because the rungs fit badly.

| Item | Desk | Private | Nested | Real hw | Note |
|---|---|---|---|---|---|
| The two questions (findings home, audit cadence) | no | no | no | no | Guidance. |
| State-file contract — `next:` ≤ 3, every open item referenced, `handoff:` drained first | no | part | yes | yes | Shape-matching rules a script can check. Exercisable today against a fixture state file once G14's validator exists. |
| Routing a finding to three destinations | no | part | no | no | Behavioural; needs sessions. |
| Decision records written before execution; never silently edited | no | part | no | no | Behavioural; checkable in git history after the fact. |
| Verification-by-live-artifact standard | no | part | part | yes | Shown by cases where it was or wasn't followed. |
| Secrets follow the direction the file travels | part | part | yes | yes | Mechanical in part — scan results are checkable. |
| Maintenance pass, both drift directions | no | part | no | no | Needs the passage of months to show either direction. |
| "Write for the weakest session" | no | no | no | no | Shown only by weak sessions actually following it. |

Almost none of this is reached by any single-run environment. The Private deployment is both its source and its only test, which is why `field-evidence.md` refuses to count it. See [G15](roadmap.md).

## What the whole picture says

Where each rung is cheap, where it's expensive, and what it is blind to:

| Rung | Cost | Reaches well | Blind to |
|---|---|---|---|
| `L1` Desk | An afternoon per block, no hardware | Command syntax, prerequisites, anything with a vendor doc — including the bootloader fork | Everything behavioural; everything without a vendor |
| `L2` Private | A session at the maintainer's server | Passthrough, IOMMU, containers, inference, GPU behaviour on one real machine | Bring-up; single-GPU lockout; other platform branches; circular items |
| `L3` Nested | A VM and a weekend | Install, `qm`/`pvesh`, host bridges, guest Docker, CPU inference, blast radius | All of the hardware-dependent half |
| `L3`/`L4` Real hw | A purchase | Everything, on that one machine | Other machines |

The consequence for sequencing is the one the roadmap already implies, now with the reason attached: **`L1` and `L3`-Nested between them cover the command syntax and the install path; `L2`-Private covers the passthrough half; only a build covers both ends and the bring-up block.** None of the first three can stand in for the fourth, and each can fail to find a bug the others find.

## What no rung gives you

- **Coverage across hardware.** `unreached: none` on one build means none on that build. The block's own named suspect — "consumer motherboards with less clean IOMMU grouping" — is a claim about *other* machines, and one `L3`-bare run can only agree or disagree for one. A second `L4` report on different hardware is worth more than a second run on the same one.
- **Coverage across platform branches.** `host-platform` offers five outcomes and every environment here reaches at most one. This is structural, not a backlog item.
- **Anything about time.** `agent-operations` and the `awaiting-human` contract are claims about what happens after weeks and months. A one-session run shows the shape is right, not that it holds.

## Where each artifact stands

*The frontmatter in each block's `AGENTS.md.example` is authoritative for the rung; this table can drift from it, and nothing yet checks that it hasn't ([G17](roadmap.md)).*

| Artifact | Category | Rung today | Next reachable | Via | Blocked on |
|---|---|---|---|---|---|
| `proxmox-ai-stack` | Full ladder | `L0` | `L1` | G10 | nothing |
| `host-platform` | Partial | `L0` | `L1` (thin), `L2` (one branch) | G10, G11 | nothing |
| `network` | Partial | `L0` | `L1`, `L3`-Nested for bridge creation | G10, G12 | nothing |
| `hardware-bringup` | Partial | `L0` | `L1` (thin); real evidence needs a build | G10, G2 | a real purchase |
| `agent-operations` | Poor fit | `L0` | undefined — see G15 | G15 | maintainer's call on the ladder |
| `discovery/*` | Off the ladder | n/a | transcript on the guidance axis | G3 | a cold reader |
| `start-here/` | Off the ladder | n/a | transcript on the guidance axis | G2, G3 | a cold reader |

**To update this table when something moves:** change the frontmatter and the block's `README.md` first (CI checks the README mentions the frontmatter's rung — a weak check: it passes if the string appears anywhere, so it won't catch a README that names the wrong rung alongside the right one), then this row, then metric 2 in `roadmap.md`. If a pass finds a cell above was wrong, correct the cell and say so in the commit — a prediction that turns out wrong is the useful outcome, the same way a divergence is the product of `L2`.
