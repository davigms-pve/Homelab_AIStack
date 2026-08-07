# Network checklist

Follow the Discovery & Advisory Cadence (`docs/methodology.md`) — this is a decision stage. The Proxmox-side bridge creation at the end is the one piece of actual execution, and that follows the Agent Operating Cadence instead.

## Topology

- **Segmented or flat?** Read `.homelab-state.yml`'s `wants` list from discovery. Home automation or any IoT-class device is the strongest signal for segmentation — these devices commonly phone home or get compromised, and isolating them from the servers segment limits the blast radius. A single workload with no untrusted devices can stay flat.
- **If segmented, how many segments and what's each for?** Don't over-segment for its own sake — each additional VLAN is another thing that can be misconfigured. A common minimum: one segment for trusted infrastructure (the host platform, domain-block VMs), one for anything IoT/untrusted.
- **Subnet range per segment** — pick ranges that don't collide with anything already in use (existing router subnet, existing IoT VLAN, a VPN range, etc.).

## Hardware capability

- **Does the existing router/switch support VLAN tagging (802.1Q)?** If hardware isn't chosen yet, this feeds back into `discovery/hardware-envelope.md` — not every consumer router supports this.
- **Which physical NIC(s) does the host platform have, and which one carries the VLAN trunk?**

## Bridge mapping

- **Bridge-to-VLAN mapping on the host platform** — e.g. a trunk bridge plus one VLAN-tagged sub-interface per segment. This is the field domain blocks read instead of asking their own networking questions.

## Addressing

- **Static reservations or DHCP with reservations?** Either is fine; what matters is that it's decided once and domain blocks don't each invent their own approach.
- **Where reservations are tracked** — the router's own reservation table is usually simplest; note the approach in `HOMELAB.md` either way so it's not tribal knowledge.

## Internal DNS (decision flag only)

- **Is hostname resolution planned, or are domain blocks on raw IPs for now?** Don't build a DNS resolver here — that's a future core-services block. Just record the intent so domain blocks know what to expect.

## What must never be touched

- Any existing VLAN or subnet already relied on by other devices — check before assuming a range is free.
- Any existing DHCP reservation or static assignment already in use.

The output of this checklist: `decisions.network_scheme`, `decisions.vlans`, `decisions.bridge_mapping` in `.homelab-state.yml` (see `docs/manifest-schema.md`), plus a one-line *why* in `HOMELAB.md`'s log.
