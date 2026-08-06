# Changelog

Format: one entry per phase/version tag, per the build cadence in [`docs/roadmap.md`](docs/roadmap.md).

Versioning is pre-1.0 `0.x.y`. `1.0` requires at least one path dogfooded end-to-end against real hardware — see the versioning section in the roadmap for what that means concretely.

## [Unreleased] — pre-0.1.0

Everything below is built but untagged. No version has been declared working yet: both blocks ship `unverified`, and the open gaps are tracked in [`docs/roadmap.md`](docs/roadmap.md).

### Added
- Repo hygiene: `LICENSE` (MIT), `.gitignore`, `CONTRIBUTING.md`, root `AGENTS.md` / `CLAUDE.md`.
- `docs/methodology.md` — CEP method, Discovery & Advisory Cadence, Agent Operating Cadence, validation rules, link-vetting rule.
- `docs/index.md`, `docs/block-schema.md`, `docs/manifest-schema.md`.
- `docs/roadmap.md` — build cadence (phases 0–7), pre-1.0 versioning policy, the three tracking metrics, and the running list of open gaps.
- `discovery/` — needs, hardware-envelope, and AI-tooling discovery as CEP triples, plus a `README.md` human entry point.
- `blocks/host-platform/` — foundation block (decision layer: bare OS vs. Proxmox vs. other hypervisor).
- `blocks/proxmox-ai-stack/` — first domain block, currently unverified.
- `.github/` issue and PR templates.

### Fixed (review pass, 2026-08-06)
- Flagship `README.md` claimed it had been dogfooded against real hardware while its own frontmatter read `last-verified: unverified`. Now honestly marked unverified in both places, and in the root `README.md`.
- `blocks/host-platform/` carried no validation status at all, in violation of the rule in `docs/block-schema.md`. Now marked unverified.
- Both `AGENTS.md.example` files were largely `<<PLACEHOLDER>>` tokens rather than filled examples — contradicting `docs/block-schema.md`, `docs/methodology.md`, and the repo's own central argument that blanks are useless to an agent. Both rewritten with realistic fake values inline; each `PLACEHOLDERS.md` is now a find-and-replace map.
- `blocks/proxmox-ai-stack/CHECKLIST.md` was missing four facts an agent would have been blocked on: how it reaches the host, the single-GPU console-lockout risk, the `q35` + OVMF requirement, and in-VM GPU driver plus container-runtime setup.
- `docs/manifest-schema.md` documented four `decisions:` keys while `discovery/` instructed agents to write ten others verbatim.
- References to a "build cadence" and "planning history" pointed at a plan file that doesn't exist in the repo. They now resolve to `docs/roadmap.md`.
