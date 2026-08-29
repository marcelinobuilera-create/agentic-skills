---
name: loop
description: Use when a task is too large to complete in one step — running implementations, debugging sessions, refactors, or migrations to verified completion through an explicit act-verify-repeat loop with exit criteria defined up front.
---

# Loop

## Overview

Big tasks fail in one of two ways: they stop early ("good enough") or they never
stop (infinite tinkering). The loop prevents both by forcing an explicit
definition of done, one small verified step per iteration, and a visible
checklist that decides when to exit.

**Core principle: a task is done when every exit criterion has evidence —
not when the last edit was made.**

## The loop

```
DEFINE → SELECT → ACT → VERIFY → UPDATE → (repeat) → EXIT
```

1. **DEFINE** — Before any work, write "done" as a checklist of concrete,
   checkable criteria: `build passes`, `test X green`, `file Y exists`,
   `endpoint returns 200`, `docs updated`. Vague criteria ("works well")
   are banned; make them testable.
2. **SELECT** — Pick the single smallest action that moves one criterion forward.
3. **ACT** — Execute it: one edit, one command, one change.
4. **VERIFY** — Run the check attached to that criterion and capture the real
   output. Green means evidence exists; red means the next iteration targets it.
5. **UPDATE** — Mark the criterion done, park blockers with a reason, and add
   any newly discovered criteria the work revealed.
6. **REPEAT** from SELECT. **EXIT** only when every criterion has evidence.

## Rules

- One criterion minimum per iteration — never batch changes you have not verified.
- Evidence comes from this iteration's output, never from memory.
- Blocked twice on the same criterion → change approach or escalate; do not
  repeat attempt #3.
- Keep the checklist visible across iterations (todo list or notes) so progress
  is auditable.
- New work discovered mid-loop becomes a new criterion — it is either added
  explicitly or explicitly deferred, never silently absorbed.

## Exit conditions

- Every criterion is checked with captured evidence (command output, test
  result, file listing).
- A closing summary exists: what changed, where, evidence references, and
  leftovers / known limits.

## Common mistakes

- Defining "done" after starting — that is how scope creep hides.
- Marking criteria done from memory instead of observed output.
- Looping without updating the checklist — the loop loses its exit condition.
- Treating a parked blocker as done. Parked ≠ complete; it stays visible.
