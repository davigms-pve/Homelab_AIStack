# Hardware bring-up checklist

Two cadences apply, and the switch happens partway through. Checkpoints 1 and 2 are advisory — there's no infrastructure to touch, so follow the **Discovery & Advisory Cadence** (`docs/methodology.md`). From the moment the machine answers on the network at checkpoint 3, the **Agent Operating Cadence** takes over and stays in force.

**Standing rule for this whole block: never invent a specification.** Torque values, RAM slot ordering, front-panel pinouts, firmware key combinations — these differ per component and are in the manual that shipped with it. Point at the manual or the vendor's own documentation, per the link-vetting rule in `CONTRIBUTING.md`. Supplying current, general knowledge is your job; supplying numbers you can't source is not.

Before starting, check `assumes:` against `comfort_level` and say any mismatch out loud with its fallback — see `start-here/TRAVERSAL.md`.

## Checkpoint 1 — before any money moves

The highest-value gate in this block. Everything here is cheap to fix now and expensive to fix after delivery.

- **Does every line of the candidate parts list satisfy `decisions.hardware_envelope`?** Go line by line, out loud. Not "does this look like a good machine" — does it meet the envelope that was written down.
- **Drive bays: does the case hold the number in the envelope, physically?** The most common regret in storage builds. Bays cost almost nothing at purchase and cannot be added later.
- **Are there enough drive connectors on the board for that bay count?** A case with eight bays and a board with four connectors is a build that stops halfway.
- **Does the power supply carry what hasn't been bought yet?** If the envelope reserves a slot for a GPU in a later phase, the supply has to be sized for it now — otherwise phase three means replacing it.
- **If `media` is in `wants`: does the CPU have hardware video encoding?** Without it, transcoding consumes the whole processor and the media block underdelivers.
- **If `ai-stack` is in `wants`: is there a free PCIe x16 slot, and does a full-length card physically fit the case?** Slot count and physical clearance are different questions and both fail silently.
- **What's the board's maximum memory, not just what's being bought?** Memory is the cheapest later upgrade; a board at its ceiling on day one forecloses it.
- **Does the chosen `decisions.host_platform` actually support this hardware?** Check the platform's own documentation for the network and storage controllers specifically — that's where support gaps usually are.
- **Are the drives new?** Used is a false economy for the one component whose failure loses data. Say so plainly if used drives are being considered.
- **Record why each part was chosen, not just what.** This goes in the work order. When something is out of stock — and something will be — the reason is what lets a substitution be made without a round trip.

**If `physical-assembly` isn't met:** the validated list is exactly what a shop builds to, and pre-built machines can be matched against the same envelope. Take that path and rejoin at checkpoint 3.

**Before releasing them to buy:** write the work order to `HOMELAB.md`, set `blocks: hardware-bringup: awaiting-human`, and fill the `awaiting:` record with `checkpoint: parts-ordered` and an `agent-resumes-by` naming what you'll verify on return.

## Checkpoint 2 — assembled, before installing anything

Ask these as questions the person can answer by looking, not by knowing.

- **Does it power on and reach the firmware screen?** If not, the fault is almost always power, memory seating, or a front-panel connector — and the manual covers all three.
- **Are all the drives listed in the firmware?** Count them against what was bought. A missing drive here is a warranty claim; a missing drive discovered after data is on the array is something else.
- **Is the full amount of memory recognized?** A stick that isn't seated shows up as a smaller number, not as an error.
- **Is the boot media detected?**
- **Universal safety, and this is the whole safety section:** unplugged before opening, ground yourself before handling components, never force a connector that isn't going in, confirm the supply is adequate before first boot. These have been true for twenty years and will still be true when this file is old.

**Before releasing them to install:** update the `awaiting:` record to `checkpoint: assembled`.

## Checkpoint 3 — platform installed, first connection

This is the gate everything downstream waits on.

- **Which platform, and which version, was actually installed?** Record it — later blocks check against this, and "whatever was current" ages badly.
- **Is it on the network, and at what address?** At this stage the address is whatever the existing router handed out. That's fine and temporary; `blocks/foundation/network/` formalizes addressing afterwards.
- **Is remote access enabled and reachable from the machine the agent runs on?** Have them confirm it responds before you try.
- **Connect, and verify against what you were told.** Read actual state — drives present, memory seen, platform version — and compare it to the parts list and the envelope. This is Agent Operating Cadence step 1, and it's the first honest check that the machine is what everyone believes it is.
- **Report any drift immediately.** A drive that didn't survive assembly, memory reading low, a platform version different from the plan. Cheaper to know now than three blocks later.
- **What must never be touched:** nothing on this machine yet belongs to another workload, but the person's existing network does. Don't change router configuration, DHCP ranges, or anything off this host — `blocks/foundation/network/` owns that, and it hasn't run.

The output of this checklist: `decisions.host_access` (method and address — **never credentials, tokens, or keys**; see `docs/manifest-schema.md`), a record of what was actually built, `blocks: hardware-bringup: done`, the `awaiting:` record deleted, and a one-line *why* in `HOMELAB.md`'s log.
