# Proxmox + AI stack checklist

Everything here should be resolved and recorded in `.homelab-state.yml` before the Agent Operating Cadence starts executing changes. Where a value isn't known yet, that's a gap to close with the human first, not to assume.

## Host and identity

- **Node name(s)** — which Proxmox node(s) exist, and which one this VM lives on.
- **How the agent reaches the host** — SSH (which user? `root@pam` or an unprivileged account with `sudo`?), a Proxmox API token, or `pvesh` running locally on the node. Operating Cadence step 1 is "read current state," and that's impossible without this. Record the *method and identity*, never the secret itself — tokens and keys belong in a password manager or an agent's own credential store, not in an `AGENTS.md` that gets committed.
- **Existing VM/LXC IDs in use** — so a new ID doesn't collide, and so the agent knows what it must never touch.
- **Storage pool** — which pool the new VM's disk goes on, and confirmation it isn't the pool backing something else already running.

## GPU passthrough

- **GPU PCI address** (e.g. `01:00.0`) — get this from `lspci -nn | grep -i vga` on the host, not assumed.
- **How many GPUs does the host have, and does it need one for its own console?** Resolve this *before* any driver config. On a single-GPU machine, blacklisting the driver to pass the card through leaves the Proxmox host **headless** — no local console, recoverable only over the network or by booting rescue media. If there's only one GPU, either accept that tradeoff deliberately (network access must be known-good first) or don't pass it through at all. This is the most common way this block's work becomes hard to undo.
- **IOMMU group** — confirm the GPU is in its own IOMMU group or isolable (`find /sys/kernel/iommu_groups/ -type l`). If it shares a group with something the host needs, passthrough won't be clean.
- **Driver blacklist status on the host** — the host should not bind its own driver to a card being passed through. Blacklist by the specific device being passed through; never blanket-blacklist in a way that also captures a console GPU.
- **IOMMU enabled in firmware** — VT-d on Intel, AMD-Vi on AMD, plus the kernel command line (`intel_iommu=on` / `amd_iommu=on`). Confirm rather than assume; this is a BIOS-level change a human has to make.

## Networking

- **VLAN / bridge** — which Proxmox network bridge the VM attaches to, and whether it needs its own VLAN for isolation from other homelab traffic.
- **Static IP or DHCP reservation** — how the VM will be reachably addressed for SSH/API access after creation.

## VM configuration

- **VM ID** — the new, unused ID being created.
- **Machine type and firmware** — `q35` (not the default `i440fx`) and `OVMF (UEFI)` (not SeaBIOS), which also needs an EFI disk allocated. These are effectively required for clean PCIe passthrough, and they are painful to change after the OS is installed — decide them at creation time, not later.
- **Resource allocation** — vCPU count, RAM, disk size — should trace back to the hardware envelope from discovery, not be picked arbitrarily.
- **OS choice for the VM** — typically a Debian/Ubuntu base that then runs Docker.

## What must never be touched

- Any other VM/LXC ID already in use on the node.
- Storage pools backing other running workloads.
- The host's own network bridge configuration beyond attaching this one VM.
- **Any GPU the host uses for its own console.** If the host has a second card driving local output, it stays bound to the host — passing it through or blacklisting its driver is how a node becomes unreachable with no console to fix it from.

## AI stack layer (inside the VM, once it's up)

- **GPU driver inside the VM** — passthrough only makes the hardware visible; the guest still needs the vendor's driver installed before anything can use it. Verify with `nvidia-smi` (or the vendor equivalent) *inside* the VM before moving on. If this fails, nothing downstream will work, and the cause is here rather than in the container layer.
- **Container GPU runtime** — Docker cannot reach the GPU without a container toolkit installed in the VM, even when the VM itself sees the card fine. Verify by running a vendor image with `--gpus all` and confirming it prints the card. This is a distinct step from the driver above, and skipping it produces containers that silently run on CPU.
- **Which LLM runtime and chat interface** — official sources only, confirm current install instructions from their own docs rather than assuming they match `AGENTS.md.example` verbatim (software changes faster than this repo does).
- **Model size vs. available VRAM** — from the hardware envelope; don't let the agent pull a model larger than the passed-through GPU can hold. Oversized models don't error out cleanly, they fall back to CPU and get very slow, which reads like a performance problem rather than a configuration one.
- **Port(s) exposed** and whether they're reachable only on the internal network or intentionally exposed further — confirm intent before opening anything up.
