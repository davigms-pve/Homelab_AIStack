# Host platform checklist

Follow the Discovery & Advisory Cadence (`docs/methodology.md`) — this is still a decision stage, not execution yet.

Work through which priority axis actually matters most before narrowing to a specific platform — jumping straight to "hypervisor or not" is what makes this decision look narrower than it is.

## Which axis matters most

- **Is reliable/redundant storage the primary workload?** Someone whose main goal is a NAS-like setup (media libraries, backups, file shares) is optimizing for storage first, not compute isolation — that's a different question than "how many workloads."
- **How many workloads, and do they need isolation from each other?** Reading `.homelab-state.yml`'s `wants` list from discovery: one workload (e.g. just an AI stack) tolerates running directly on the host; two or more (e.g. AI stack + media + home automation) usually benefits from VM/LXC separation so one misbehaving service can't take down another.
- **Does GPU passthrough to an isolated VM matter?** If the hardware envelope calls for a GPU and the person wants it dedicated to one workload (not shared across containers on the bare host), that pushes toward a hypervisor.
- **Is minimal operational overhead the priority over flexibility?** Someone who wants "a handful of Docker apps behind a simple dashboard, nothing to administer" is optimizing for simplicity, which can outweigh both storage and isolation concerns for a beginner comfort level.
- **Comfort level, from discovery.** A hypervisor adds a layer of things that can go wrong (passthrough config, virtual networking). A beginner comfort level with only one workload wanted is a real signal against a hypervisor by default — but check that against the storage and simplicity axes above before defaulting to bare Docker, since a beginner who mainly wants a NAS is still better served by a storage-first platform than by raw Docker Compose.

## Cross-cutting checks, once an axis is chosen

- **Recovery/snapshot needs.** Hypervisors give VM-level snapshots almost for free; bare OS needs a separate backup strategy. Does this matter to them?
- **Existing hardware constraints.** Passthrough requires IOMMU support and a motherboard/CPU that supports it — if hardware is already chosen, confirm this before committing to a hypervisor path.
- **Which specific platform.** Proxmox is this repo's flagship worked example (see `blocks/domains/proxmox-ai-stack/`) for the isolation-first axis; the decision itself isn't limited to it — record whichever is actually chosen, on whichever axis it came from.

The output of this checklist is one field: `decisions.host_platform` in `.homelab-state.yml` (e.g. `bare-docker`, `proxmox`, `truenas-scale`, `openmediavault`, `casaos`, or another named platform), plus a one-line *why* in `HOMELAB.md`'s log — including which axis drove the decision.
