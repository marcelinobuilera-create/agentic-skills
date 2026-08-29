#!/usr/bin/env bash
# Mini eval harness: RED (task only) vs GREEN (task + full skill body appended),
# graded structurally against the scenario rubric.
# ponytail ceiling: grading is grep-only — it can check format/evidence markers,
# not reasoning quality; JUDGE: lines are surfaced for a human or grader agent,
# never auto-passed. A grep PASS proves format, not behavior.
set -euo pipefail
cd "$(dirname "$0")/.."
usage() {
  echo "usage: eval.sh list" >&2
  echo "       eval.sh run <scenario> [--runs N] [--cmd 'TEMPLATE with {prompt}']" >&2
  exit 2
}
die() { echo "eval.sh: $*" >&2; exit 1; }
skill_of() { sed -n 's/^# Skill:[[:space:]]*//p' "$1" | head -1; }
task_of()  { awk '/^# Task:/{sub(/^# Task:[[:space:]]*/, ""); print; next} /^# Skill:/{exit} {print}' "$1"; }

list() {
  local f
  for f in scenarios/*.md; do
    [ -e "$f" ] || die "no scenarios found under scenarios/"
    printf '%-24s skill-under-test: %s\n' "$(basename "$f" .md)" "$(skill_of "$f")"
  done
}

# grade <scenario-file> <arm> <output-file>; green-arm failures accumulate in
# the caller's green_fails/green_graded.
grade() {
  local line pat fails=0
  echo "== arm: $2  file: $3 =="
  if [ ! -f "$3" ]; then
    echo "   (no output yet — run the prompt, save output there, re-run)"
    return 0
  fi
  while IFS= read -r line; do
    case "$line" in GREP:*|JUDGE:*) ;; *) continue ;; esac
    pat=${line#*:}; pat=${pat# }
    if [ "${line%%:*}" = GREP ]; then
      if grep -qiE -- "$pat" "$3"; then
        printf '   PASS  GREP: %s\n' "$pat"
      else
        printf '   FAIL  GREP: %s\n' "$pat"
        fails=$((fails + 1))
      fi
    else
      printf '   JUDGE (needs human): %s\n' "$pat"
    fi
  done < "$1"
  printf '   -> %s: %d grep failure(s)\n' "$2" "$fails"
  if [ "$2" = green ]; then
    green_fails=$((green_fails + fails))
    green_graded=$((green_graded + 1))
  fi
}

run_scenario() {
  local scenario="$1" runs=1 cmd="" arm prompt quoted i r
  shift
  while [ $# -gt 0 ]; do
    case "$1" in
      --runs) [ $# -ge 2 ] || usage; runs="$2"; shift 2 ;;
      --cmd)  [ $# -ge 2 ] || usage; cmd="$2";  shift 2 ;;
      *) usage ;;
    esac
  done
  case "$scenario" in ''|*/*) usage ;; esac
  case "$runs" in ''|*[!0-9]*) die "--runs wants a positive integer" ;; esac
  [ "$runs" -ge 1 ] || die "--runs wants >= 1"

  local file="scenarios/${scenario}.md" task skill body
  [ -f "$file" ] || die "unknown scenario '$scenario' (try: eval.sh list)"
  task=$(task_of "$file"); skill=$(skill_of "$file")
  [ -n "$skill" ] || die "$file: missing '# Skill:' line"
  if   [ -f "skills/${skill}/SKILL.md" ]; then body="skills/${skill}/SKILL.md"
  elif [ -f "agents/${skill}.md" ];       then body="agents/${skill}.md"
  else die "no skill/agent named '$skill' (scenario: $scenario)"; fi

  local out="results/${scenario}"
  mkdir -p "$out/prompts"
  printf '%s\n' "$task" > "$out/prompts/red.md"
  { printf '%s\n\n---\n\nFollow this skill exactly:\n\n' "$task"; cat "$body"; } > "$out/prompts/green.md"
  echo "prompts: $out/prompts/{red,green}.md"

  if [ -z "$cmd" ]; then
    # Honest fallback: no agent CLI wired in, so execution is manual.
    echo "no --cmd: prompts written; execution is manual/agent-driven."
    echo "save each arm's output to $out/<arm>-<run>.txt (e.g. $out/green-1.txt)"
    echo "then re-run: eval.sh run $scenario"
  else
    case "$cmd" in *'{prompt}'*) ;; *) die "--cmd template must contain {prompt}" ;; esac
    for arm in red green; do
      prompt=$(cat "$out/prompts/${arm}.md")
      for ((i = 1; i <= runs; i++)); do
        quoted=$(printf '%q' "$prompt")
        echo "running $arm-$i: ${cmd/\{prompt\}/<prompt>}"
        # ponytail ceiling: {prompt} is shell-quoted and substituted into a
        # single bash command line — TEMPLATE must be a bash cmdline, not argv.
        bash -c "${cmd//\{prompt\}/$quoted}" > "$out/${arm}-$i.txt" 2>&1 \
          || echo "   (command exited non-zero; output kept for grading)"
      done
    done
  fi

  green_fails=0; green_graded=0
  for ((r = 1; r <= runs; r++)); do
    grade "$file" red   "$out/red-$r.txt"
    grade "$file" green "$out/green-$r.txt"
  done
  if [ "$green_fails" -gt 0 ]; then
    echo "RESULT: FAIL — $green_fails grep rubric(s) failed on the green arm"
    exit 1
  elif [ "$green_graded" -eq 0 ]; then
    echo "RESULT: no green output to grade yet"
  else
    echo "RESULT: PASS — green arm greps satisfied ($green_graded graded; JUDGE items need a human)"
  fi
}

case "${1:-}" in
  list) list ;;
  run)  [ $# -ge 2 ] || usage; run_scenario "$2" "${@:3}" ;;
  *)    usage ;;
esac
