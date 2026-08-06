# Contributing

Fork, branch, PR. Nothing unusual there. What's specific to this repo is what a contribution has to include before it's mergeable.

## Definition of Done

A new or edited block is done when:

- [ ] It's a complete **CEP triple** — `README.md`, `CHECKLIST.md`, `AGENTS.md.example`, `PLACEHOLDERS.md` all present (see `docs/block-schema.md`).
- [ ] **`AGENTS.md.example` reads as a finished file, not a form.** Realistic fake values inline, no `<<TOKEN>>` placeholders left in it. A reviewer should be able to read it start to finish as though it were somebody's real, working `AGENTS.md`. This is the checklist item most easily passed by accident — file presence is not the test.
- [ ] `PLACEHOLDERS.md` is a find-and-replace map: each fake value, what it means, where the reader's own value comes from.
- [ ] The `CHECKLIST.md` would actually let an agent finish the job. Ask concretely: given only this block, would an agent know how to *reach* the infrastructure, and what could it destroy by following the steps in order?
- [ ] It declares its `requires:` prerequisites honestly, if any.
- [ ] `AGENTS.md.example` references `docs/methodology.md`'s cadences rather than restating them.
- [ ] It's been validated: either dogfooded live and marked so, or it carries `last-verified` / `verified-against` frontmatter, or — if genuinely untested — it's explicitly marked **unverified** in its `README.md`. Don't ship a block that silently implies it's been tried when it hasn't.
- [ ] Any values in `AGENTS.md.example` are fake-but-realistic. No real IPs, hostnames, tokens, or serial numbers.
- [ ] Discovery and hardware/tooling content states criteria, not brand picks — see `docs/index.md` for why.

## Link-vetting rule

Any link to a runnable stack, tool, or piece of software must point at its official/vendor source — the project's own repository, own documentation, or own release page. Do not link third-party reimplementations, unofficial mirrors, or random blog forks, even if they're popular. Reviewers check this on every PR that adds a link.

## Adding a new block

New categories (media, home automation, personal cloud/backup, etc.) are welcome — see the roadmap in the root `README.md` for what's already planned. Follow the existing blocks (`blocks/host-platform/`, `blocks/proxmox-ai-stack/`) as the reference shape rather than inventing a new structure.

## Pull requests

Use the PR template — it includes the same checklist above as an attestation. A reviewer should be able to check every box against the diff without guessing.
