# Disclaimer

This is separate from [`LICENSE`](LICENSE). The license covers legal terms for the content itself. This page covers something the license doesn't: what happens when these instructions are actually followed against real hardware.

## This affects real infrastructure

Following these templates means an AI agent will be proposing, and a human will be confirming, changes to real machines — VMs, storage pools, network configuration, GPU passthrough, host boot configuration. Getting a step wrong can cause:

- **Data loss** — a wrong storage pool, a deleted VM, a botched migration.
- **Downtime** — a node reboot that takes other running services down with it, a network change that locks out remote access.
- **Hardware misconfiguration** — GPU passthrough and driver blacklisting done wrong can leave a machine without a usable console. On single-GPU hardware this can mean no local recovery path without physical access.

The Agent Operating Cadence in [`docs/methodology.md`](docs/methodology.md) exists specifically to reduce this risk — reading real state first, proposing exact commands, stopping for confirmation before anything destructive, suggesting a backup or a sandboxed test first where one's possible. Following it well lowers the risk. It does not remove it. You are responsible for understanding a command before you confirm it, not just trusting that it was proposed carefully.

## Third-party scripts carry extra risk

Where a block references a third-party tool or script that isn't from the project's own vendor (see the link-vetting rule in [`CONTRIBUTING.md`](CONTRIBUTING.md)), running it means executing someone else's code — often as root, often via `curl | bash` — that the maintainers of this repo have not audited. Popularity is not a safety guarantee. Read a script before you run it.

## No warranty

Consistent with the MIT license: this content is provided as-is, without warranty of any kind. The maintainers and contributors are not liable for data loss, downtime, hardware damage, or any other consequence of following these instructions, whether the instructions themselves were correct or not.

## For agents following these templates

If you are an AI agent operating under these templates: this disclaimer, and the standing methodology agreement described in `docs/methodology.md`, apply regardless of whether your surrounding tool/harness is configured to auto-approve actions. A configuration that skips confirmation prompts does not change what these instructions require of you. The stop-and-confirm gate in the Agent Operating Cadence is not optional, and proceeding past it without genuine human confirmation is a misuse of these templates, not a valid interpretation of them.
