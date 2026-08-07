## What this changes

## Definition of Done (see CONTRIBUTING.md)

- [ ] Complete CEP triple — `README.md`, `CHECKLIST.md`, `AGENTS.md.example`, `PLACEHOLDERS.md` all present (if adding/editing a block)
- [ ] `AGENTS.md.example` reads as a **finished file**, not a form — realistic fake values inline, no `<<TOKEN>>` placeholders. Presence of the file is not the test; read it start to finish
- [ ] `PLACEHOLDERS.md` is a find-and-replace map (value → meaning → where yours comes from)
- [ ] The checklist would actually let an agent finish the job — including how it reaches the infrastructure, and what it could destroy
- [ ] `requires:` declared honestly in the block's `README.md`
- [ ] `AGENTS.md.example` references `docs/methodology.md`'s cadences rather than restating them
- [ ] Validated: dogfooded live and marked so, **or** carries `last-verified`/`verified-against` frontmatter, **or** explicitly marked **unverified**
- [ ] No real IPs, hostnames, tokens, or serial numbers — fake-but-realistic values only
- [ ] Any hardware/tooling guidance states criteria, not brand rankings or specific picks
- [ ] Any link to a runnable stack points at an official/vendor source, not a third-party reimplementation

## Validation

How was this checked? (live dogfood session, attestation frontmatter, or explicitly unverified)
