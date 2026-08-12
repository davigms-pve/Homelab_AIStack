# What to replace

`AGENTS.md.example` is the operating half of a finished `AGENTS.md`, not a form. Replace each value below with your own.

| Fake value in the example | What it means | Where yours comes from |
|---|---|---|
| `homelab-md` | Where findings live, because this fictional homelab has no issue tracker | Your own answer — `github-issues` if you run one on your own repo |
| `monthly`, `2026-08-01` | Maintenance-pass cadence, and when it last ran | Your own answer; monthly is a good default. The date is real and moves each pass |
| `2026-08-04-ollama-cold-start`, `2026-08-09-floating-tags` | Finding ids in the `date-slug` form | Generated as you find things — the form is what matters, not these |
| `pve1`, VM `101`, VM `105`, `192.0.2.105:11434` | The host, the NAS VM, the AI VM, and the inference endpoint | From `foundation/host-platform`, `foundation/network`, and your domain block |
| `ai-stack/docker-compose.yml`, `ai-stack/.env` | The repo-to-live deploy pair | Wherever your own deploying files actually live |
| `/etc/pve/lxc/101.conf` | A live-to-repo mirrored file, shown with its provenance header | Whichever live files you mirror into your repo as backups |
| `/opt/homelab/backup-check.sh` | A cron job used to illustrate the PATH gotcha | Any scheduled job you actually run |
| `12W` idle / `180W` under inference | A measured constant, shown as an example of an operative fact | **Measure your own.** Copying someone else's numbers is the exact failure this section exists to prevent |

## The part that isn't a find-and-replace

**"Facts about this homelab" must be emptied and refilled, not adapted.** Every line in that section is a fact about a machine that doesn't exist, and several are opinionated in ways that are wrong elsewhere — the `soft` NFS mount is right *because* that specific NAS VM reboots for updates, and would be the wrong call on a NAS that doesn't. Keep the section and its rule (operative facts live in the file every session loads); throw the contents away and let yours accumulate one debugging session at a time.

The same applies to the mechanical guards at the end. Yours should replace instructions you have personally already broken — that's what makes them worth having, and it's why the list can't be inherited.

**What you should copy nearly verbatim:** the state-file contract, the finding-routing table, the proof standard, the secrets-direction rule, and the maintenance-pass list. Those are structural and don't depend on your hardware.
