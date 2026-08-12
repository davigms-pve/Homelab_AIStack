# Field evidence — where this repo's operating rules came from

*Recorded 2026-08-12.*

Most of this repo is written from official documentation and reasoning, and says so — every block sits at `L0` on the [verification ladder](methodology.md). One part doesn't: the operating rules in [`blocks/foundation/agent-operations/`](../blocks/foundation/agent-operations/), plus several rules now embedded in the methodology and the manifest schema, came out of a real deployment rather than research.

This page is the ledger for that. It exists so a reader can tell which claims have field experience behind them and which don't, without either being quietly upgraded.

## The deployment

A private, single-server homelab: Proxmox, dual GPUs, local LLM inference behind an orchestrator, one container per service. Operated day to day **by AI agents** under a docs-as-system-of-record model, for months. Not a lab exercise and not a demo — a system its owner depends on, where a wrong `docker compose down` costs real uptime.

The rules below are what survived contact with that. They're the *operating* experience, not the *bring-up* experience: the deployment was already built when this repo started, so nothing here validates the buying, assembly, or installation path.

## The honesty caveat, stated once

**This is not verification, and it does not move any block up the ladder.**

Two reasons, both worth being explicit about:

1. **It's a different repo.** The deployment is one opinionated setup that grew around one owner, one server, and one working relationship with AI agents. This repo is a template layer. Rules that worked there are a strong prior, not a proof they generalize.
2. **It's partly circular.** The same deployment informed some of this repo's content, so agreement between the two is weak evidence — the block may just be describing that machine back to itself. This is exactly why `L2` on the ladder demands a **divergence log** rather than a claim of having checked; divergences are the product, agreement isn't.

`agent-operations/` therefore ships at `L0` like everything else, despite having the strongest provenance in the repo. Provenance is not a rung.

## Where each lesson went

Routed rather than collected. A lesson filed in a document nobody opens at the moment it applies is the same lesson lost — which is itself one of the lessons below.

| Lesson from the field | Where it now lives |
|---|---|
| A rule that isn't mechanically enforced will be broken by a future session | `.github/workflows/validate-blocks.yml` + the CI section of `CONTRIBUTING.md`; restated as a standing question in `agent-operations/` |
| State files rot toward journals unless given a structural contract | `manifest-schema.md` — "The contract that keeps this file a pointer"; enforced in `agent-operations/CHECKLIST.md` |
| A finding that lives only in prose is a finding lost | `agent-operations/` finding-routing table; finding ids in `manifest-schema.md` |
| Decisions get written down before they're executed, and never silently edited | `manifest-schema.md` `HOMELAB.md` rules; `agent-operations/CHECKLIST.md` |
| Credentials and interactive auth stay owner-only | `methodology.md`, after the Agent Operating Cadence |
| Deploys, logs, and plausible output all lie — verify against a live artifact | `methodology.md` cadence step 7; "Done when" in `proxmox-ai-stack/CHECKLIST.md` |
| Secrets follow the direction the file travels | `manifest-schema.md`; full rule in `agent-operations/` |
| Plan → execute, and stop at surprises rather than routing around them | `methodology.md` cadence steps 5–6 |
| Write for the weakest session that will ever follow the instructions | `agent-operations/CHECKLIST.md`; it's also why CI exists rather than another checklist bullet |
| Audit on a cadence, and check both failure directions | `agent-operations/` maintenance pass |
| Container gotchas — digest pinning, `$$` escaping, capturing `Cmd` before removal | `proxmox-ai-stack/CHECKLIST.md`, where containers actually live |

Three gotchas from the same source have **no home in this repo yet** and were deliberately not forced in: NFS `soft` mounting (no storage block), cron `PATH` behavior (no scheduled-job content), and syntax-checking before restarting a service (no service-management content). They appear only as realistic content inside `agent-operations/AGENTS.md.example`, illustrating what an operative fact looks like — not as guidance this repo offers. They're tracked as gaps in [`roadmap.md`](roadmap.md).

## What deliberately wasn't copied

The deployment's exact file set, issue conventions, and cadence. Those grew around one situation. What transferred is the *shape* — mechanical guards, structural state contracts, evidence-first closes, decision records before action — and the concrete layout stays whatever the CEP blocks and [`manifest-schema.md`](manifest-schema.md) already define.
