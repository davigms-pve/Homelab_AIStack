# What to replace

`AGENTS.md.example` is a finished, working instruction file — not a form with blanks. Every value in it is fake but realistic, so you can read the whole thing and see the shape you're aiming at before you change anything.

To make it yours: copy it to `AGENTS.md` in your own repo, then find-and-replace each value below. Work top to bottom — the table is ordered roughly the way the example introduces them.

| Fake value in the example | What it means | Where yours comes from |
|---|---|---|
| `pve1` / `pve1.lan` | Proxmox node hostname | Your node's actual name, from the Proxmox web UI or `hostname` |
| `root@pve1.lan` | How the agent reaches the host | Your own access method — SSH user/host, or an API token ID. Never paste the secret itself into `AGENTS.md` |
| `Proxmox VE 8.2` | Host platform version | `pveversion` on your node |
| `01:00.0` | PCI address of the GPU being passed through | `lspci -nn \| grep -i vga` on the host |
| `00:02.0` | PCI address of the GPU driving the host console | Same command. **If you only have one GPU, see the warning below** |
| `12GB` VRAM | VRAM on the passed-through card | The card's spec, or `nvidia-smi` once the driver is loaded |
| `105` | New, unused VM ID | Any free ID — check with `pvesh get /nodes/<node>/qemu` |
| `100` (router), `101` (NAS) | Existing VMs that must never be touched | Your own in-use IDs, from the same command. Name what they actually do |
| `8` vCPUs / `32GB` RAM | Resources allocated to the AI VM | Your hardware envelope from `discovery/hardware-envelope.md`, not a guess |
| `local-zfs` | Storage pool for the VM's disk | Your pool name, from Datacenter → Storage in the web UI |
| `tank` | A pool in use by something else, off-limits | Your own other pools, if any |
| `vmbr0` | Network bridge the VM attaches to | Your bridge name, from the node's Network tab |
| `192.0.2.105` | The AI VM's address | Your own IP or DHCP reservation. `192.0.2.0/24` is a reserved documentation range and will not work on a real network |
| `2026-08-06` | Date of the log entry | The actual date you did it |

## Two things worth getting right

**If you have only one GPU,** the example does not apply as written. It assumes a separate onboard GPU keeps the host console alive. Blacklisting the driver for your only GPU leaves the Proxmox host headless — no local console, recoverable only over the network or by booting rescue media. Resolve this before touching driver config; it's the first item in `CHECKLIST.md` for exactly this reason.

**Don't leave a value half-replaced.** A literal `pve1` left in a file otherwise adapted to your setup is worse than an obvious blank, because it looks legitimate — an agent will read it as a real hostname and act on it. Search your finished `AGENTS.md` for every value in the left column before you use it.
