#!/usr/bin/env bash
#
# Secret and real-address scan for this repo.
#
# CONTRIBUTING.md's Definition of Done says: "Any values in
# AGENTS.md.example are fake-but-realistic. No real IPs, hostnames, tokens,
# or serial numbers." Until now nothing enforced that — validate-blocks.sh
# checks CEP structure and leftover <<TOKEN>> placeholders, not secrets.
#
# This repo's own doctrine is the argument for closing that gap: a rule that
# isn't mechanically enforced gets broken by a future contributor, or a
# future session, however prominently it's written down. This repo is also
# public, and it ships deliberately realistic values — which is exactly the
# condition under which a real value slips in unnoticed, because it looks
# like every value around it.
#
# Two checks, both chosen because a machine can decide them without judgment:
#
#   1. Credential shapes. A real API key, PAT or private key has a
#      recognisable form and is never legitimate here.
#   2. IPv4 literals outside the documentation and private ranges. A
#      fake-but-realistic homelab example belongs in RFC 5737 TEST-NET or
#      RFC 1918 space. Anything else is either a real address or a bad
#      example. The repo already gets this right (192.0.2.x, 198.51.100.x),
#      so this locks in existing practice rather than imposing a new one.
#
# Deliberately NOT checked: hostnames and serial numbers. No script can tell
# `pve1` from somebody's real node name — that stays human review, which is
# the split CONTRIBUTING.md already describes.
#
# POSIX-ish bash, same as validate-blocks.sh, so it runs identically on a CI
# runner and locally before opening a PR:
#
#     bash .github/scripts/secret-scan.sh
#
# Prints every problem found rather than stopping at the first, and exits
# non-zero if there were any.

set -uo pipefail

failures=0

fail() {
	printf '  %s\n    %s\n' "$1" "$2" >&2
	failures=$((failures + 1))
}

# ---------------------------------------------------------------------------
# 1. Credential shapes
# ---------------------------------------------------------------------------
# Each alternative is anchored on a vendor prefix plus a length floor, so
# ordinary prose can't trip it.
CREDENTIALS='ghp_[A-Za-z0-9]{36}'
CREDENTIALS="$CREDENTIALS|github_pat_[A-Za-z0-9_]{22,}"
CREDENTIALS="$CREDENTIALS|gho_[A-Za-z0-9]{36}|ghs_[A-Za-z0-9]{36}|ghr_[A-Za-z0-9]{36}"
CREDENTIALS="$CREDENTIALS|sk-ant-[A-Za-z0-9_-]{20,}"
CREDENTIALS="$CREDENTIALS|sk-[A-Za-z0-9]{32,}"
CREDENTIALS="$CREDENTIALS|sk-lf-[0-9a-f]{8}|pk-lf-[0-9a-f]{8}"
CREDENTIALS="$CREDENTIALS|xox[baprs]-[A-Za-z0-9-]{10,}"
CREDENTIALS="$CREDENTIALS|AKIA[0-9A-Z]{16}"
CREDENTIALS="$CREDENTIALS|AIza[0-9A-Za-z_-]{35}"
CREDENTIALS="$CREDENTIALS|-----BEGIN (RSA |EC |DSA |OPENSSH |PGP )?PRIVATE KEY-----"
CREDENTIALS="$CREDENTIALS|eyJ[A-Za-z0-9_-]{20,}\.eyJ[A-Za-z0-9_-]{20,}"

while IFS= read -r hit; do
	[ -n "$hit" ] || continue
	fail "$hit" "looks like a real credential — never commit one, even to a public example"
done < <(grep -rInE --binary-files=without-match \
	--exclude-dir=.git --exclude-dir=.github \
	"$CREDENTIALS" . 2>/dev/null | cut -c1-200)

# ---------------------------------------------------------------------------
# 2. IPv4 literals outside documentation / private / local ranges
# ---------------------------------------------------------------------------
# Allowed:
#   192.0.2.0/24, 198.51.100.0/24, 203.0.113.0/24  RFC 5737 documentation
#   10/8, 172.16/12, 192.168/16                    RFC 1918 private
#   127/8   loopback      169.254/16  link-local
#   224-239 multicast     0.x and 255.255.255.255  unspecified/broadcast
allowed_ip() {
	case "$1" in
	192.0.2.* | 198.51.100.* | 203.0.113.*) return 0 ;;
	10.* | 192.168.* | 127.* | 169.254.* | 0.* | 255.255.255.255) return 0 ;;
	172.1[6-9].* | 172.2[0-9].* | 172.3[0-1].*) return 0 ;;
	22[4-9].* | 23[0-9].*) return 0 ;;
	esac
	return 1
}

while IFS= read -r line; do
	[ -n "$line" ] || continue
	# grep -o output is "path:lineno:match"; the match is the final field.
	ip=${line##*:}
	allowed_ip "$ip" && continue
	fail "$line" "IPv4 outside RFC 5737 documentation and RFC 1918 private ranges — use 192.0.2.x or 198.51.100.x for examples"
done < <(grep -rInoE --binary-files=without-match \
	--exclude-dir=.git --exclude-dir=.github \
	'\b(25[0-5]|2[0-4][0-9]|1[0-9]{2}|[1-9]?[0-9])(\.(25[0-5]|2[0-4][0-9]|1[0-9]{2}|[1-9]?[0-9])){3}\b' \
	. 2>/dev/null)

# ---------------------------------------------------------------------------

if [ "$failures" -gt 0 ]; then
	printf '\nsecret-scan: %d problem(s) found.\n' "$failures" >&2
	exit 1
fi

echo "secret-scan: clean — no credential shapes, no out-of-range IPv4 literals."
