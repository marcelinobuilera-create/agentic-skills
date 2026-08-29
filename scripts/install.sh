#!/usr/bin/env bash
# Idempotent installer for agentic-skills: copies skills/<name>/ directories
# into a skills dir and agents/*.md into an agents dir. Re-running overwrites
# in place — ponytail: no versioning or backup on overwrite; the ceiling is
# that local edits to previously installed copies are lost (upgrade path:
# add a backup/ diff step if that ever bites).
set -euo pipefail

root="$(cd "$(dirname "$0")/.." && pwd)"
skills_dir="$HOME/.claude/skills"
agents_dir="$HOME/.claude/agents"
dry_run=0

usage() { echo "usage: $0 [--skills-dir DIR] [--agents-dir DIR] [--dry-run]" >&2; exit 2; }

while [ $# -gt 0 ]; do
  case "$1" in
    --skills-dir) [ $# -ge 2 ] || usage; skills_dir="$2"; shift 2 ;;
    --agents-dir) [ $# -ge 2 ] || usage; agents_dir="$2"; shift 2 ;;
    --dry-run)    dry_run=1; shift ;;
    *)            usage ;;
  esac
done

count=0
declare -a paths=()

for src in "$root"/skills/*/; do
  [ -d "$src" ] || continue
  dest="$skills_dir/$(basename "$src")"
  echo "skill: $src -> $dest"
  if [ "$dry_run" -eq 0 ]; then
    mkdir -p "$skills_dir"
    rm -rf "$dest"      # idempotence via replace: the dir is copied fresh each run
    cp -R "$src" "$dest"
  fi
  paths+=("$dest")
  count=$((count + 1))
done

for src in "$root"/agents/*.md; do
  [ -f "$src" ] || continue
  dest="$agents_dir/$(basename "$src")"
  echo "agent: $src -> $dest"
  if [ "$dry_run" -eq 0 ]; then
    mkdir -p "$agents_dir"
    cp "$src" "$dest"
  fi
  paths+=("$dest")
  count=$((count + 1))
done

echo
if [ "$count" -eq 0 ]; then
  echo "nothing to install: no skills/*/ or agents/*.md found under $root" >&2
  exit 1
fi
if [ "$dry_run" -eq 1 ]; then
  echo "dry run — nothing written; would install $count item(s):"
else
  echo "installed $count item(s):"
fi
printf '  %s\n' "${paths[@]}"
