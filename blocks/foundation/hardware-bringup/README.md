# Hardware bring-up

requires: [foundation/host-platform]
assumes: [physical-assembly, os-install, bios-firmware]

*Foundation-tier block — see `docs/block-schema.md` for what that means.*

The gap between "we decided what to build" and "there's a machine an agent can reach." Buying the parts, assembling them, installing the platform, getting it on the network, turning on remote access. Every other block in this repo either happens before this or after it; none of them cover it.

If you already own a running server, skip this block entirely — mark it `excluded` and carry on. If you own a laptop and an idea, this block *is* your project, and everything else waits on it.

## This block does not teach you to build a PC

Deliberately. Assembly instructions go stale, differ per component, and duplicate the manual that came in the box — and a repo that tried to carry them would be the fixed tutorial `docs/index.md` opens by rejecting.

What this block owns is the **protocol**: three checkpoints, what must be verified at each, how the work is handed to you, and how an agent picks the thread back up weeks later. The actual guidance — which parts, whether they fit together, what "good" looks like this year — comes from your agent at the time, where it can be current, and from the vendor's own documentation.

**The value here is the gates, not the guidance.** A wrong parts list gets caught at checkpoint 1 by checking it against the spec envelope, no matter who produced it or how confident they sounded. That's the durable part. If you're reading this and it feels thin, that's the design — please don't fill it with a build tutorial.

## What this block produces

- A **work order** in your own `HOMELAB.md`: what to buy and *why each part is what it is*, so you can substitute sensibly when something's out of stock.
- `decisions.host_access` — how an agent reaches the finished machine, and at what address. Never credentials; see `docs/manifest-schema.md`.
- A record of what was actually built, so later blocks can check reality against the envelope instead of trusting it.

## The three checkpoints

1. **Before money moves.** A candidate parts list is checked line by line against `decisions.hardware_envelope`. Catching a case with too few drive bays costs a conversation here; catching it after delivery costs a rebuild.
2. **After assembly, before the OS.** Does it power on, are all the drives visible, is all the memory seen. This is the checkpoint that catches a dead drive while it's still a warranty claim.
3. **After the platform is installed.** You enable remote access; the agent connects for the first time and verifies the machine against what it was told. That connection is the boundary — everything before it is advice, everything after is the Agent Operating Cadence.

Between checkpoints the block sits at `awaiting-human` with an `awaiting:` record naming what's being waited on, so a gap of weeks doesn't lose your place.

## If you'd rather not build it yourself

Then don't — this is a supported path, not a lesser one. The spec envelope discovery produced is exactly what a shop needs to build to, and pre-built machines can be matched against it the same way. You rejoin at checkpoint 3 with a working machine, and nothing downstream knows or cares who assembled it. See the `assumes:` fallbacks in `docs/block-schema.md`.

## Validation

**Unverified.** Not yet walked with a real person buying real parts. The protocol was designed from a cold walkthrough that surfaced this gap (see `docs/roadmap.md`), not from a completed build — so treat the checkpoints as sound and the specific verification questions as a first draft.
