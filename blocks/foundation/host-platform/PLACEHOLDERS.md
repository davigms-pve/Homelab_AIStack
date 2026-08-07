# What to replace

`AGENTS.md.example` is a finished decision record, not a form with blanks. The values in it are fake but realistic, so you can see what a completed one reads like — including the reasoning, which is the part that matters most here.

To make it yours: copy it, then replace each value below with your own.

| Fake value in the example | What it means | Where yours comes from |
|---|---|---|
| `proxmox` | The platform actually chosen | Your own answer, on whichever axis drove it — `bare-docker`, `proxmox`, `xcp-ng`, `truenas-scale`, `openmediavault`, `casaos`, or whatever you land on |
| `[ai-stack, media]`, priority `ai-stack` | What you want to run, and what comes first | `discovery/needs.md` |
| `beginner-docker` | Your stated technical comfort level | `discovery/needs.md` — be honest, it changes the recommendation |
| `under-1000`, apartment, closet shelf | Budget and physical constraints | `discovery/needs.md` |
| 6–8 cores / 32GB / 12GB VRAM / 2+ bays | The hardware envelope | `discovery/hardware-envelope.md` |
| `true` (gpu_passthrough) | Whether a GPU goes to one isolated VM | Your own answer — `false` is common and fine |
| `pve1` | Hostname of the physical machine | Whatever you name it during install |
| `VT-d` | The IOMMU setting on your CPU | VT-d on Intel, AMD-Vi on AMD |
| `2026-08-06` | Date of the decision | The actual date |

## The part that isn't a find-and-replace

The **reasoning** in "The decision" section is the one thing you shouldn't copy. Swapping `proxmox` for `bare-docker` while leaving the justification about VM isolation intact produces a decision record that argues for something you didn't choose — worse than no record at all, because the next person to read it (probably you, months later) will believe it.

Write your own two or three sentences covering what you chose, what you chose it over, and what you gave up. That's what the example is demonstrating; the specific values around it are just scaffolding.
