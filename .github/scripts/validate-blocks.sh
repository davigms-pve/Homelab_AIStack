#!/usr/bin/env bash
#
# Structural validation for this repo's blocks.
#
# This exists because of a lesson that cost a real deployment four repeats of
# the same mistake: a rule that isn't mechanically enforced gets broken by a
# future session, no matter how prominently it's written down. Every check
# below used to be a bullet in CONTRIBUTING.md that a contributor attested to
# by ticking a box.
#
# POSIX-ish bash with grep/sed/awk and nothing else, so it runs identically on
# a CI runner and on a contributor's machine before they open a PR:
#
#     bash .github/scripts/validate-blocks.sh
#
# Prints every problem found rather than stopping at the first, and exits
# non-zero if there were any.

set -uo pipefail

REPO="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
cd "$REPO" || exit 2

problems=0

fail() {
	printf '  %s: %s\n' "$1" "$2" >&2
	problems=$((problems + 1))
}

# Strip CRs so the same script works on a Windows checkout and a CI runner.
clean() { tr -d '\r' <"$1"; }

# fm_get FILE KEY — value of KEY inside the leading `---` frontmatter fence.
fm_get() {
	clean "$1" | awk -v want="$2" '
		NR == 1 { if ($0 != "---") exit; next }
		/^---[[:space:]]*$/ { exit }
		{
			i = index($0, ":")
			if (i == 0) next
			k = substr($0, 1, i - 1); v = substr($0, i + 1)
			gsub(/^[[:space:]]+|[[:space:]]+$/, "", k)
			gsub(/^[[:space:]]+|[[:space:]]+$/, "", v)
			if (k == want) { print v; exit }
		}
	'
}

# fm_has_key FILE KEY — true if KEY appears in frontmatter, whatever its value.
# The `found` flag is load-bearing: an `exit 0` inside a rule still runs END,
# whose own exit status would override it.
fm_has_key() {
	clean "$1" | awk -v want="$2" '
		NR == 1 { if ($0 != "---") exit; next }
		/^---[[:space:]]*$/ { exit }
		{
			i = index($0, ":")
			if (i == 0) next
			k = substr($0, 1, i - 1)
			gsub(/^[[:space:]]+|[[:space:]]+$/, "", k)
			if (k == want) { found = 1; exit }
		}
		END { exit (found ? 0 : 1) }
	'
}

has_frontmatter() { clean "$1" | head -1 | grep -q '^---[[:space:]]*$'; }

rung_level() {
	case "$1" in
	L0) echo 0 ;; L1) echo 1 ;; L2) echo 2 ;; L3) echo 3 ;; L4) echo 4 ;;
	*) echo -1 ;;
	esac
}

# requires_of FILE — the raw value of the first `requires:` line, or the
# sentinel MISSING.
requires_of() {
	local line
	line="$(clean "$1" | grep -m1 '^requires:' || true)"
	if [ -z "$line" ]; then
		echo MISSING
	else
		echo "${line#requires:}"
	fi
}

blocks() { find blocks -mindepth 2 -maxdepth 2 -type d 2>/dev/null | sort; }
topics() { find discovery -maxdepth 1 -name '*.md' ! -name 'README.md' | sort; }

# ---------------------------------------------------------------- known names

known=" none discovery "
for block in $(blocks); do
	flat="${block##*/}"
	tier="$(basename "$(dirname "$block")")"
	case "$known" in
	*" $flat "*)
		fail "$block" "block name '$flat' collides with another block — names must be unique across tiers, or TRAVERSAL.md's last-path-segment rule breaks"
		;;
	esac
	known="$known$flat $tier/$flat "
done
for topic in $(topics); do
	base="${topic##*/}"
	known="$known${base%.md} "
done

check_requires() {
	local file="$1" raw entry
	raw="$(requires_of "$file")"
	if [ "$raw" = MISSING ]; then
		fail "$file" "no \`requires:\` line — every block and discovery topic declares one, \`requires: none\` included"
		return
	fi
	raw="$(printf '%s' "$raw" | tr -d '[]' | tr ',' ' ')"
	for entry in $raw; do
		case "$known" in
		*" $entry "*) ;;
		*) fail "$file" "requires: '$entry' does not resolve to any block or discovery topic" ;;
		esac
	done
}

# -------------------------------------------------------------- per-block

for block in $(blocks); do
	readme="$block/README.md"
	example="$block/AGENTS.md.example"

	for name in README.md CHECKLIST.md AGENTS.md.example PLACEHOLDERS.md; do
		[ -f "$block/$name" ] || fail "$block" "incomplete CEP triple — missing $name"
	done

	if [ -f "$example" ]; then
		# A filled example uses realistic values inline — see docs/block-schema.md.
		while IFS= read -r hit; do
			[ -n "$hit" ] && fail "$example" "line $hit — a filled example uses realistic values inline, not placeholder tokens"
		done < <(clean "$example" | grep -n -o '<<[A-Z0-9_]*>>' || true)

		if ! has_frontmatter "$example"; then
			fail "$example" "no verification frontmatter — every block declares a rung, and a new one starts at L0"
		else
			rung="$(fm_get "$example" verification)"
			level="$(rung_level "$rung")"
			lastv="$(fm_get "$example" last-verified)"
			against="$(fm_get "$example" verified-against)"
			evidence="$(fm_get "$example" evidence)"

			if [ "$level" -lt 0 ]; then
				fail "$example" "verification: '$rung' is not one of L0 L1 L2 L3 L4"
			else
				for key in last-verified verified-against evidence; do
					fm_has_key "$example" "$key" || fail "$example" "frontmatter missing \`$key:\`"
				done

				if [ "$level" -eq 0 ]; then
					for pair in "last-verified=$lastv" "verified-against=$against" "evidence=$evidence"; do
						[ "${pair#*=}" = "n/a" ] || fail "$example" "at L0, \`${pair%%=*}\` must be \`n/a\` — L0 means nobody has checked this against anything"
					done
				else
					printf '%s' "$lastv" | grep -Eq '^[0-9]{4}-[0-9]{2}-[0-9]{2}$' ||
						fail "$example" "at $rung, \`last-verified\` must be an ISO date (YYYY-MM-DD), got '$lastv'"
					case "$against" in
					"" | n/a) fail "$example" "at $rung, \`verified-against\` must name the concrete versions checked" ;;
					esac
				fi

				if [ "$level" -ge 2 ]; then
					case "$evidence" in
					http://* | https://*) ;;
					"" | n/a) fail "$example" "at $rung, \`evidence\` must point at the artifact — a rung without its artifact is not a rung" ;;
					*) [ -e "$evidence" ] || fail "$example" "at $rung, \`evidence\` points at '$evidence', which does not exist" ;;
					esac
				fi

				if [ "$level" -ge 3 ] && ! fm_has_key "$example" unreached; then
					fail "$example" "at $rung, \`unreached:\` must be present — either \`none\` or the checklist items this environment structurally could not test. \`unreached: none\` is the bare-metal claim"
				fi

				if [ -f "$readme" ] && ! clean "$readme" | grep -q "$rung"; then
					fail "$readme" "does not state its rung ($rung) in plain words — frontmatter is for CI, the README sentence is for the reader"
				fi
			fi
		fi
	fi

	[ -f "$readme" ] && check_requires "$readme"
done

for topic in $(topics); do
	check_requires "$topic"
done

# ------------------------------------------------- agent-agnostic tripwire
#
# Content an agent follows must describe capabilities, not products — see
# AGENTS.md ("This repo is agent-agnostic"). This is a tripwire, not a
# guarantee: it only knows the names listed here, so a tool added after this
# list was written passes silently. Review has to catch the rest, and anyone
# who spots a missing name should add it.
#
# Scoped to what an agent is handed (blocks/, discovery/, start-here/).
# Deliberately NOT scanned: CLAUDE.md, AGENTS.md, CHANGELOG.md and docs/,
# where naming a tool is the point (a pointer file, the branch-naming
# example, release history).

agent_names='Claude|Anthropic|ChatGPT|OpenAI|Codex|Gemini|Copilot|Cursor|Windsurf|Cline|Aider|Hermes'

while IFS= read -r hit; do
	[ -n "$hit" ] && fail "${hit%%:*}" "line ${hit#*:} names a specific AI tool — describe the capability instead (AGENTS.md, \"agent-agnostic\")"
done < <(
	for f in $(find blocks discovery start-here -type f -name '*.md*' 2>/dev/null | sort); do
		clean "$f" | grep -n -w -E "$agent_names" | sed "s#^\([0-9]*\):.*#$f:\1#"
	done
)

# ------------------------------------------------------------------- report

if [ "$problems" -gt 0 ]; then
	printf '\n%d problem(s) above.\n' "$problems" >&2
	printf 'See docs/block-schema.md and docs/methodology.md for what each rule protects.\n' >&2
	exit 1
fi

printf 'OK — %d blocks, %d discovery topics.\n' "$(blocks | wc -l)" "$(topics | wc -l)"
