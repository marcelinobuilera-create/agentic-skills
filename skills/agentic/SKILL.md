---
name: agentic
description: Use when executing any multi-step task autonomously — deciding what to do next, gathering context, making changes, and verifying results. Covers how to work agentically, how much to do per step, when to act without asking, and when to stop and ask the user.
---

# Agentic

## Overview

Owning an outcome is different from executing instructions. This skill defines
how to operate autonomously: understand before acting, make the smallest change
that reaches the goal, verify everything you claim, and escalate at the right
moment — not too early, not too late.

**Core principle: never claim done without evidence you produced yourself.**

## Operating loop

1. **Orient** — Read the task fully. List what you know and what you are
   assuming. Assumptions become explicit statements, not silent guesses.
2. **Gather context in parallel** — Batch every independent read, search, and
   command into one round before acting. Do not serialize independent lookups.
3. **Plan briefly** — Write the smallest sequence of steps that reaches "done".
   If you cannot state what "done" means, resolving that is step one.
4. **Act** — One coherent change per step. Re-read the code you are about to edit.
5. **Verify** — Run the build, test, or command that proves the step worked.
   Show or cite the actual output.
6. **Report** — What changed, where, and how it was verified. Leftovers included.

## Rules of thumb

| Situation | Do this |
|-----------|---------|
| Need a utility | Reuse what exists first: project helper > standard library > installed dependency > new code |
| Independent tool calls | Emit them together in one batch, never one per turn |
| A bug report | Fix the root cause in the shared function, not the symptom in each caller |
| Reversible action within scope | Just do it; do not ask permission |
| Destructive or irreversible action | Stop and ask first |
| Two failed attempts on the same blocker | Stop and change approach or escalate — never attempt #3 blindly |
| About to claim "done" | Verify by running something first |

## When to stop and ask

- The action is destructive, irreversible, or touches production or credentials.
- The answer would change the deliverable itself, not just its implementation.
- You are blocked twice on the same step.
- Required input (credentials, decisions, access) does not exist in the environment.

## Common mistakes

- **Claiming done without running anything.** "Should work" is not verification.
- **Editing blind.** Making changes without reading the surrounding code first.
- **Asking permission for reversible work.** Wastes a round-trip on nothing.
- **Over-building.** Layers, abstractions, and options nobody asked for.
- **Silent scope creep.** Fixing unrelated things mid-task without flagging them.
