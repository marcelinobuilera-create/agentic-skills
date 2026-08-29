---
name: agentic
description: Use when executing any multi-step task autonomously — orienting on a new task, deciding what to do next, gathering context, making changes under uncertainty, verifying results with evidence, and calibrating when to act without asking versus when to stop and ask the user. Covers root-cause discipline, the reuse ladder, and the ladder of verification.
---

# Agentic

## Overview

Competent agents finish tasks. Expert agents finish the *right* task, with
evidence, in few iterations, and leave no surprises behind.

**Core principle: never claim done without evidence you produced yourself —
and never change code you cannot trace.**

## Phase 1 — Orient

1. Read the task twice: once for the goal, once for constraints ("don't
   touch", "must stay compatible", deadlines).
2. Classify the work: new build / modify existing / debug / operate. Each has
   a different risk profile and different verification needs.
3. Write "done" in one sentence. If you can't, resolving that is step one.
4. List explicit assumptions: statements that must be true for your plan to
   work. Assumptions get stated, never smuggled.

## Phase 2 — Gather context

- Batch every independent read, search, and command into one parallel round.
  Serializing independent lookups is wasted turns.
- Read in this order: the entry point for the task → its callers and callees →
  conventions (README / AGENTS.md / existing tests) → tangents only if needed.
- Trace the real flow end to end before editing anything. Reading a function
  is not tracing it: know who calls it and what breaks when it changes.
- Stop gathering when new reads stop changing the plan.

## Phase 3 — Plan

- Smallest sequence of verifiable steps; each step names the check that
  proves it worked.
- Order steps so the riskiest assumption dies first — a plan that fails fast
  costs less than one that fails late.
- Identify the trust boundary of the change (inputs you don't control) and
  validate there, not everywhere.

## Phase 4 — Act

- One coherent change per step. Re-read the exact lines you are about to edit.
- **Root-cause rule:** a bug report names a symptom, not the bug. Fix the
  shared function once and grep every caller — one guard beats ten patches.
- **Reuse ladder:** project helper > standard library > already-installed
  dependency > new code. Deletion beats addition; boring beats clever.
- Mark deliberate simplifications with a comment naming the ceiling and the
  upgrade path, so corners cut on purpose stay visible.

## Phase 5 — Verify (ladder of evidence)

1. Parses / compiles.
2. The changed path actually runs.
3. Tests pass — including the ones you didn't touch.
4. Behavior matches the stated "done".

Below rung 4 you are not done; you are guessing with extra steps. Cite the
actual command output, not a summary of your intentions.

## Phase 6 — Report

What changed and where · how it was verified (evidence) · leftovers and known
limits · discoveries outside the original scope. No surprises: everything the
next person would want to know is on the page.

## Decide: act or ask

| Situation | Action |
|-----------|--------|
| Reversible and in scope | Act now — don't spend a round-trip asking |
| Destructive, irreversible, production, or credentials | Ask first, always |
| Ambiguity that changes the deliverable | Ask, with a proposed default |
| Ambiguity that only changes implementation | Decide, state the assumption, proceed |
| Same blocker failed twice | Change approach; a third failure means ask |
| Out-of-scope work discovered | Finish the scope; report the discovery — never silently absorb |

## Red flags

| Thought | Reality |
|---------|---------|
| "I've read enough" | Reading is not tracing; trace the flow first |
| "It probably works" | "Probably" is not evidence; run it |
| "The fix is obvious" | Obvious fixes in unfamiliar code are how second bugs are born |
| "One more small feature won't hurt" | Scope creep is a sequence of small features |
| "I'll verify at the end" | Verification deferred is verification skipped |
| "Asking looks weak" | Escalating on time is the competence signal |
