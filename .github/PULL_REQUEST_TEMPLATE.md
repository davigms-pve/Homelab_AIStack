## What this changes

## Definition of Done (see CONTRIBUTING.md)

Items marked *(CI)* are checked automatically by `.github/workflows/validate-blocks.yml` — you don't need to verify them by hand, but a red build means one of them failed.

- [ ] *(CI)* Complete CEP triple — `README.md`, `CHECKLIST.md`, `AGENTS.md.example`, `PLACEHOLDERS.md` all present (if adding/editing a block)
- [ ] *(CI)* No `<<TOKEN>>` placeholders left in `AGENTS.md.example`
- [ ] *(CI)* Verification frontmatter present and self-consistent — `verification:` is `L0`–`L4`, and the date/versions/evidence fields match what that rung requires
- [ ] *(CI)* Every `requires:` name resolves to a block or discovery topic that exists
- [ ] `AGENTS.md.example` reads as a **finished file**, not a form — realistic fake values inline. Presence of the file is not the test; read it start to finish
- [ ] `PLACEHOLDERS.md` is a find-and-replace map (value → meaning → where yours comes from)
- [ ] The checklist would actually let an agent finish the job — including how it reaches the infrastructure, and what it could destroy
- [ ] Each checklist item that changes state names its **verification artifact** — "done when: a real request returns X", not "verify it worked"
- [ ] `requires:` declared honestly, and any `assumes:` tag ships with a stated fallback
- [ ] `AGENTS.md.example` references `docs/methodology.md`'s cadences rather than restating them
- [ ] The rung is also stated in plain words in the block's `README.md`
- [ ] No real IPs, hostnames, tokens, or serial numbers — fake-but-realistic values only
- [ ] Any hardware/tooling guidance states criteria, not brand rankings or specific picks
- [ ] Nothing an agent is told to do depends on one AI tool's features (*CI* catches known product names only; the rest is review)
- [ ] Any link to a runnable stack points at an official/vendor source, not a third-party reimplementation

## Validation

**Rung claimed:** (L0 / L1 / L2 / L3 / L4 — see `docs/methodology.md`)

**Evidence artifact:** (path or URL; `n/a` at L0)

If you claimed L2 or above, say what the evidence *found*, not just that you gathered it. A retro-validation with no divergences and an execution run with nothing unreached are both worth a second look before merge.
