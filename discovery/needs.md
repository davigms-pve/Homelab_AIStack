# Needs discovery

requires: none — this is the starting point.

The first thing an agent should figure out isn't a technology, it's what the person actually wants to run and how comfortable they are getting there. This drives every later block. Follow the Discovery & Advisory Cadence in `docs/methodology.md`: one question at a time, calibrate depth to comfort level, summarize back periodically, write confirmed answers to `.homelab-state.yml` / `HOMELAB.md` immediately.

## Checklist

An agent should come away from this conversation knowing:

- **Desired categories** — which of these, if any: AI / local LLM inference, media server + automation, home automation, personal cloud / file backup, none of the above yet / just exploring.
- **Technical comfort level** — has this person used Docker before? A terminal? Do they currently self-host anything? (This is the very first question — it sets how everything after it should be phrased.)
- **Constraints** — approximate budget band, physical space available (closet vs. spare room vs. none), noise tolerance (lives near the hardware or not), power cost sensitivity.
- **Existing hardware** — is there already a machine in mind, or starting from nothing?
- **Priority order** — if more than one category is wanted, which matters most first? (Trying to stand up everything at once is a common way to stall out.)

## Example

A worked, fictional conversation outcome — this is what a completed discovery pass looks like, not a transcript to copy verbatim:

> **Categories wanted:** AI/local LLM (primary), media server (secondary, later)
> **Comfort level:** used Docker a little, never touched Proxmox or a hypervisor
> **Constraints:** ~$800 budget, has a spare closet shelf, lives in an apartment so noise matters, no existing hardware
> **Priority:** get local AI chat working first; media can wait

This maps directly into `.homelab-state.yml`:
```yaml
decisions:
  wants: [ai-stack, media]
  priority: ai-stack
  comfort_level: beginner-docker
  budget_band: under-1000
  constraints: [quiet, small-space]
```

## Placeholders

Nothing to swap in this file itself — it's the interview, not a template someone edits. The *output* of the conversation is what gets written into the user's own `.homelab-state.yml`, using the field names shown above verbatim (`wants`, `priority`, `comfort_level`, `budget_band`, `constraints`).
