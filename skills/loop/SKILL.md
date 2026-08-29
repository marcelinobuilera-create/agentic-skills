---
name: loop
description: Use when a task is too large to complete in one step — running implementations, debugging sessions, refactors, or migrations to verified completion through an explicit DEFINE-ACT-VERIFY loop with exit criteria defined up front, blocked work parked with reasons, and a hard rule that every criterion needs evidence from this session.
---

# Loop

## Overview

Big tasks fail in one of two ways: they stop early ("good enough") or never
stop (infinite tinkering). The loop prevents both: done is defined first,
each iteration moves one criterion forward with evidence, and the checklist —
not mood or momentum — decides when to exit.

**Core principle: a task is done when every exit criterion has evidence from
this session — not when the last edit was made.**

## The loop

```
DEFINE → SELECT → ACT → VERIFY → UPDATE → (repeat) → EXIT
```

1. **DEFINE** — Write "done" as a checklist of criteria *before* any work.
2. **SELECT** — The single smallest action that moves one criterion forward.
3. **ACT** — One edit, one command, one change.
4. **VERIFY** — Run that criterion's check; capture real output.
5. **UPDATE** — Close the criterion, park blockers with a reason, add newly
   discovered criteria explicitly.
6. **REPEAT** from SELECT. **EXIT** only when every criterion has evidence.

## Exit criteria quality bar

Every criterion must be:

- **Checkable by a command or test** — `pytest tests/config` green, not
  "parsing works well".
- **Ownable** — you can produce the evidence yourself, in this session.
- **Observable in output** — pass/fail shows up in a log, exit code, or file
  listing, not in your memory.

Translate vague goals on sight: "make config parsing more robust" becomes
"malformed config produces a named error, not a traceback — verified with
`load('bad.toml')`".

## Rules

- One criterion minimum per iteration — never batch unverified changes.
- Evidence comes from this iteration's output, never from memory.
- **Two-strike rule:** blocked twice on the same criterion → change approach;
  a third attempt needs a new idea or an escalation, not more effort.
- **Reopen rule:** if a later step invalidates a closed criterion, reopen it
  explicitly — a criterion stays closed only while its evidence holds.
- **Stall alarm:** three consecutive iterations with no criterion going green
  means the plan is wrong. Stop and re-plan; don't push harder.
- Keep the checklist visible across iterations so progress is auditable.
- New work discovered mid-loop becomes a criterion — added explicitly or
  explicitly deferred, never silently absorbed.

## Worked example

Task: swap the JSON config parser for TOML without breaking callers.

DONE checklist: `pytest tests/config` green (21 tests) · `load()` accepts the
old fixture file · no `import json` left under `config/` · README updated.

- **Iter 1** — SELECT: add a TOML loader behind the same interface. ACT: write
  `toml_loader.py`. VERIFY: pytest → 18 pass, 3 fail (nested defaults).
  UPDATE: tests stay open; new criterion: "document TOML type differences".
- **Iter 2** — SELECT: fix the nested-defaults merge order. ACT: change the
  merge. VERIFY: pytest → 21 pass. UPDATE: tests closed.
- **Iter 3** — SELECT: remove the JSON path. ACT: delete `json_loader`.
  VERIFY: `grep -rn "import json" config/` → empty; pytest → 21 pass.
  UPDATE: closed. **EXIT**: every criterion evidenced; report the leftover
  (YAML untouched, noted for later).

## Common mistakes

- Defining "done" after starting — that is how scope creep hides.
- Marking criteria done from memory instead of observed output.
- Looping without updating the checklist — the loop loses its exit condition.
- Treating a parked blocker as done. Parked ≠ complete; it stays visible.
- Answering the stall alarm with more effort instead of a better plan.
