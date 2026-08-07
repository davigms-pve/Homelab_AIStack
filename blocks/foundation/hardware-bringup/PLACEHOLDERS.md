# Placeholders — hardware bring-up

`AGENTS.md.example` is a finished work order for a fictional homelab, not a form. To make it yours, find-and-replace the values below. Everything else in that file is reasoning you should keep.

| Value in the example | What it means | Where yours comes from |
|---|---|---|
| `pve1` | The node/hostname of the machine being built | You choose it during the platform install. Short and boring beats clever. |
| `192.0.2.50` | The address the host answered on at first connection | Whatever your existing router hands out during install. Temporary — `blocks/foundation/network/` formalizes it later. |
| `ssh` / `root` | How the agent reaches the host, and as whom | Set during the platform install. **Never record the password or key alongside it** — `.homelab-state.yml` records how to reach the host, never what proves you may. |
| `Proxmox VE 8.2` | The platform and version actually installed | Your `decisions.host_platform` choice, at whatever version was current when you installed it. Record the real one — "whatever was current" ages badly. |
| 8 cores / 32GB / 2 drives / 12GB VRAM | The as-built machine | Your own `decisions.hardware_envelope`, then what you actually bought. Record both: the envelope is what you aimed at, `machine_as_built` is what exists. |
| `2026-08-06`, "eleven days later" | Dates and elapsed time in the `awaiting:` record | Real dates as you go. The elapsed gap is the point of the record — it's what makes a four-week wait resumable. |
| The parts table's left column | Item descriptions | Researched against your envelope at the time you order. |

## What deliberately has no placeholder

**Model numbers.** The example describes parts rather than naming them, and that isn't laziness or squeamishness — anything specific written into this repo is wrong within a year. Your agent researches current parts against your envelope at checkpoint 1, and the model numbers live in *your* `HOMELAB.md`, not here.

**The "why" column.** It isn't a placeholder because you shouldn't replace it wholesale — the reasoning mostly transfers, and it's the half of the work order that still helps when a part is out of stock and you're deciding what to swap in.
