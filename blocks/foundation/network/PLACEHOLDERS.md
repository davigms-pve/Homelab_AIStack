# What to replace

`AGENTS.md.example` is a finished decision record, not a form. Replace each value below with your own.

| Fake value in the example | What it means | Where yours comes from |
|---|---|---|
| `segmented-vlan` (two VLANs) | Whether the network is segmented at all, and into how many pieces | Your own answer — `flat` is common and fine for a single trusted workload |
| `10`, `servers`, `192.0.2.0/24` | First VLAN ID, name, and subnet | Whatever you actually assign — avoid colliding with an existing range |
| `20`, `iot`, `198.51.100.0/24` | Second VLAN, reserved for a future home-automation block | Only relevant if you're segmenting; drop entirely if staying flat |
| `pve1` | Host platform node name | From `blocks/foundation/host-platform/` |
| `vmbr0` / `vmbr0.10` | Trunk bridge and VLAN-tagged sub-interface names | Whatever your actual Proxmox bridge naming ends up being |
| router DHCP reservations | Addressing approach | Your own answer — static-in-VM is equally valid, just less centralized |
| `2026-08-06` | Date of the decision | The actual date |

## The part that isn't a find-and-replace

The **reasoning** for segmenting (or not) is specific to what's actually on your wishlist. Copying "segmented because home automation was on the list" while you have no interest in home automation produces a decision record arguing for something you don't need. Write your own sentence covering what you chose and why — flat is a completely legitimate choice for a lot of setups, not a fallback for people who didn't get to the "real" answer.
