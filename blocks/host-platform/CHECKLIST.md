# Host platform checklist

Follow the Discovery & Advisory Cadence (`docs/methodology.md`) — this is still a decision stage, not execution yet.

- **How many workloads, and do they need isolation from each other?** Reading `.homelab-state.yml`'s `wants` list from discovery: one workload (e.g. just an AI stack) tolerates running directly on the host; two or more (e.g. AI stack + media + home automation) usually benefits from VM/LXC separation so one misbehaving service can't take down another.
- **Does GPU passthrough to an isolated VM matter?** If the hardware envelope calls for a GPU and the person wants it dedicated to one workload (not shared across containers on the bare host), that pushes toward a hypervisor.
- **Comfort level, from discovery.** A hypervisor adds a layer of things that can go wrong (passthrough config, virtual networking). A beginner comfort level with only one workload wanted is a real signal to recommend bare OS, not Proxmox by default.
- **Recovery/snapshot needs.** Hypervisors give VM-level snapshots almost for free; bare OS needs a separate backup strategy. Does this matter to them?
- **Existing hardware constraints.** Passthrough requires IOMMU support and a motherboard/CPU that supports it — if hardware is already chosen, confirm this before committing to a hypervisor path.
- **Which platform, if a hypervisor is chosen.** Proxmox is this repo's flagship worked example (see `blocks/proxmox-ai-stack/`); the decision itself isn't limited to it — record whichever is actually chosen.

The output of this checklist is one field: `decisions.host_platform` in `.homelab-state.yml` (e.g. `bare-docker`, `proxmox`, or another named hypervisor), plus a one-line *why* in `HOMELAB.md`'s log.
