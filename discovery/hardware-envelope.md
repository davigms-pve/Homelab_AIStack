# Hardware envelope discovery

requires: [needs]

This is not a buyer's guide — specific products go stale in months and this repo doesn't track them. Instead, it turns what someone wants to run (from `needs.md`) into a **spec envelope**: the characteristics hardware needs to have, not a part number. Actual purchasing decisions get pointed at official/vendor sources, per the link-vetting rule in `CONTRIBUTING.md`.

## Checklist

- **Workloads** — pull straight from the `wants` list in `.homelab-state.yml`. Each one has different implications:
  - AI / local LLM inference → needs VRAM. Ask what size of model matters to them (small/fast vs. larger/slower is a real tradeoff, not a technicality to skip).
  - Media server + automation → transcoding needs CPU (or a GPU with hardware encode); storage needs capacity, not speed.
  - Home automation → lightweight, almost any hardware works; low idle power matters more since it runs 24/7.
  - Personal cloud / backup → storage capacity and redundancy matter more than compute.
- **Concurrency** — running one workload or several at once? Multiple workloads chosen in `needs.md` means the envelope has to sum their requirements, not just take the max.
- **Drive bays / storage growth** — does the person expect to grow storage over time, or is this fixed?
- **Idle power budget** — does electricity cost matter to them (from `needs.md` constraints)?
- **Noise / space** — closet, spare room, or living space? This affects whether a loud rackmount server is even viable.
- **Budget band** — already captured in `needs.md`; carry it forward here rather than re-asking.

## Example

Continuing the persona from `needs.md` (wants AI stack primary, media later, ~$800, apartment, quiet):

> **Output spec envelope:**
> - 6–8 CPU cores, modern generation
> - 32GB+ RAM (headroom for a hypervisor plus a mid-size local model)
> - One free PCIe x16 slot or built-in GPU capable of running local inference — VRAM target depends on model size preference, flag this as a follow-up if unresolved
> - 2+ drive bays, expandable later for the media block
> - Idle power under ~15W preferred (apartment, cost-sensitive)
> - Quiet/fanless preferred over rackmount
>
> This envelope, not a specific SKU, is what gets handed to official vendor documentation and reviews to find an actual match.

## Placeholders

None to swap directly — like `needs.md`, this is a reasoning process, not a template. Its output — the spec envelope — is written into `.homelab-state.yml` under a `hardware_envelope` key so later blocks (like `host-platform`) can read it instead of re-deriving it.
