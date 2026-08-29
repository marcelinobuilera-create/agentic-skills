#!/usr/bin/env bash
# Validates that every skill and agent file has well-formed frontmatter.
# Fails (non-zero exit) if any file is missing name/description, has an
# invalid name, or carries a description over the 1024-char spec limit.
set -u
cd "$(dirname "$0")/.."

fail=0

check() {
  local file="$1" kind="$2" body name desc
  if [ ! -f "$file" ]; then echo "FAIL missing: $file"; fail=1; return; fi
  head -1 "$file" | grep -q '^---$' || { echo "FAIL $file: no frontmatter"; fail=1; return; }
  body=$(sed -n '2,/^---$/p' "$file")
  name=$(echo "$body" | sed -n 's/^name:[[:space:]]*//p' | head -1)
  desc=$(echo "$body" | sed -n 's/^description:[[:space:]]*//p' | head -1)
  [ -n "$name" ] || { echo "FAIL $file: missing name"; fail=1; }
  [ -n "$desc" ] || { echo "FAIL $file: missing description"; fail=1; }
  echo "$name" | grep -qE '^[a-z0-9][a-z0-9-]*$' || { echo "FAIL $file: bad name '$name'"; fail=1; }
  [ "${#desc}" -le 1024 ] || { echo "FAIL $file: description >1024 chars"; fail=1; }
  [ "$fail" -eq 0 ] && echo "OK   $kind $name (${#desc}-char description)"
  return 0
}

for f in skills/*/SKILL.md; do check "$f" skill; done
for f in agents/*.md; do check "$f" agent; done

exit $fail
