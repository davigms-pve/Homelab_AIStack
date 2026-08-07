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

## Consistency checks

An envelope can be individually reasonable on every line and still describe a machine that doesn't exist. Before writing `hardware_envelope` to `.homelab-state.yml`, check the set against itself. Each of these is a real conflict, not a style preference:

- **`wants` includes `ai-stack`, but the envelope has no GPU or VRAM figure.** Local LLM inference is the one workload that can't be satisfied by "any hardware." If the envelope doesn't name a VRAM target, either the want is out or the envelope is wrong.
- **A silent/fanless preference alongside a discrete GPU.** These don't coexist. Quiet-under-load is achievable; passively cooled with a discrete GPU is not. One of the two has to give, and the person decides which.
- **A low idle-power target alongside a discrete GPU.** A discrete card idles well above a NUC-class machine — a sub-15W idle target and an inference GPU describe two different computers.
- **A VRAM target the budget band can't reach.** Check the two against each other explicitly. If they don't meet, the resolution is either a wider band, a smaller model-size expectation, or accepting prior-generation/used hardware — all three are legitimate, and it's the person's call which.
- **Media in `wants` with fixed, non-expandable storage.** Media libraries grow; a fixed bay count is a decision to re-buy later.
- **A beginner `comfort_level` alongside an envelope that requires GPU passthrough.** Not a contradiction — passthrough is learnable — but it's a real learning curve that should be named out loud rather than discovered halfway through the flagship block.

**Never resolve one of these silently.** Per the Discovery & Advisory Cadence, surface the conflict, explain the tradeoff in one or two sentences, and let the person choose. An envelope that quietly dropped somebody's stated noise constraint is worse than one that asked.

## Example

Continuing the persona from `needs.md` (wants AI stack primary, media later, ~$800, apartment, quiet):

Two of the consistency checks above fired on this persona, and the conversation resolved both rather than writing them down as open questions:

> **Conflict surfaced:** they wanted quiet and fanless, and they wanted local LLM inference. Explained that inference needs VRAM, VRAM means a discrete card, and a discrete card rules out fanless — but quiet-under-load is still very achievable in a closet. **They chose:** keep the AI stack, accept a fan, hold the noise requirement at "not audible from the next room."
>
> **Conflict surfaced:** a sub-15W idle target and a discrete GPU describe different machines. **They chose:** relax the idle target to ~35W once the tradeoff was priced out loud in rough monthly terms.
>
> **Output spec envelope:**
> - 6–8 CPU cores, modern generation
> - 32GB RAM (headroom for a hypervisor plus a mid-size local model)
> - Discrete GPU required, ~12GB VRAM target — enough for the mid-size models they described wanting, on one free PCIe x16 slot
> - 2 drive bays now, expandable later for the media block
> - Idle power ~35W (relaxed from the original preference, knowingly)
> - Quiet under load; fanless ruled out by the GPU decision
>
> **Noted tension, not a blocker:** ~$800 is tight for a 12GB card plus the rest of the machine at current-generation prices. Flagged to them that prior-generation or used hardware is the usual way that band and that VRAM target meet, and that the alternative is a smaller model-size expectation. Left as their purchasing call, since this repo doesn't track prices.
>
> This envelope, not a specific SKU, is what gets handed to official vendor documentation and reviews to find an actual match.

Note what this example is demonstrating: not just the output, but an agent hitting two of the consistency checks and walking the person through each tradeoff instead of quietly picking one. That's the part worth copying. The resulting values are exactly what appears under `hardware_envelope` in `docs/manifest-schema.md` — the same fictional homelab, carried through without drift.

## Placeholders

None to swap directly — like `needs.md`, this is a reasoning process, not a template. Its output — the spec envelope — is written into `.homelab-state.yml` under a `hardware_envelope` key so later blocks (like `host-platform`) can read it instead of re-deriving it.
