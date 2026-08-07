# Network

requires: [discovery]
assumes: [network-hardware]

The decision every domain block was quietly assuming someone else had already made.

*`network-hardware` applies only if you segment. Configuring VLANs on a router or switch is vendor-specific and not everyone wants to learn it — the fallback is to stay flat, which is a real supported choice rather than a lesser one. See `docs/block-schema.md`.* Before this block existed, `blocks/domains/proxmox-ai-stack/CHECKLIST.md` asked "which VLAN/bridge" as if it were that block's own question — it isn't. This block owns the network topology decision; domain blocks consume it.

## What this block produces

- **Segmented or flat.** Whether the network splits into isolated VLANs (common once home automation or IoT devices are in the picture — they're a frequent source of "call home" traffic nobody wants reaching the rest of the LAN) or stays one flat network (fine for a single trusted workload with no untrusted devices).
- **Subnet ranges per segment**, if segmented.
- **Bridge-to-VLAN mapping on the host platform** — which Proxmox bridge (or VLAN-tagged sub-interface) domain blocks attach to for which segment. This is the field domain blocks read instead of asking their own networking questions.
- **Addressing approach** — static reservations vs. DHCP with reservations, and where those reservations are tracked.
- **Whether internal DNS resolution exists yet** — a decision flag only. *Running* a self-hosted DNS/adblock service is a **core services** concern (see `docs/block-schema.md`) and isn't built by this block; this block just records whether one's planned, so domain blocks know whether to expect hostname resolution or use raw IPs for now.

## What this block does not cover

Physical switch/router-side VLAN tagging is vendor-specific (UniFi, pfSense, a generic consumer router's web UI all differ) — this block covers the topology decision and the Proxmox-side bridge configuration, and points at your router/switch vendor's own documentation for the tagging steps themselves, per the link-vetting rule in `CONTRIBUTING.md`.

## When to use this

**Last of the three foundation blocks**, after `blocks/foundation/host-platform/` has chosen a platform and `blocks/foundation/hardware-bringup/` has produced a machine that answers. The order isn't arbitrary: the checklist below asks which physical NICs the host has and which one carries the VLAN trunk, and nobody can answer that about a machine that doesn't exist yet. All three must be resolved before any domain block starts, since domain blocks declare `requires: [foundation/host-platform, foundation/hardware-bringup, foundation/network]`.

## Validation

**Unverified.** Not yet walked end-to-end with a real person on real hardware. See `docs/roadmap.md` for the open gap.
