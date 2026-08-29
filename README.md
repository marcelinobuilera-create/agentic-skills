# Agentic Skills

A collection of agent skills and agent definitions, written in the
[Agent Skills](https://agentskills.io/specification) format (`SKILL.md` with
YAML frontmatter) so any compatible agent runtime can load them.

Written to an expert bar: dense, battle-tested rules, decision tables,
red-flag tables, and worked examples — not generic advice.

## Contents

| Path | Type | What it does |
|------|------|--------------|
| `skills/agentic/` | Skill | Expert operating system for autonomous work: orient and trace before editing, risk-first planning, a ladder of evidence, and act-vs-ask calibration with a red-flag table. |
| `skills/loop/` | Skill | Expert act-verify-repeat loop: a quality bar for exit criteria, two-strike and reopen rules, a stall alarm, and a full worked example. |
| `agents/visioner.md` | Agent | Expert strategist agent producing a Vision Brief with kill criteria, assumption tests, and an M0 that attacks the riskiest assumption first. |
| `agents/planner.md` | Agent | Turns a Vision Brief or goal into an Implementation Plan: ordered riskiest-first steps, each with files, a verification command, and a checkable done criterion. |
| `agents/implementer.md` | Agent | Executes a plan one step per iteration under loop discipline: captured evidence, no silent redesign, deviations flagged back to the planner. |
| `agents/reviewer.md` | Agent | Adversarial review against the plan's acceptance criteria: scope audit, re-runs verification itself, APPROVE / REQUEST_CHANGES with tagged findings. |
| `skills/security/` | Skill | Hard gates for agents: secrets hygiene, trust boundaries (shell/SQL/path/prompt injection), destructive operations, supply chain, least privilege. |
| `scripts/install.sh` | Tool | Idempotent installer into `~/.claude/skills` and `~/.claude/agents`. |
| `scripts/eval.sh` | Tool | RED-vs-GREEN eval harness driven by `scenarios/*.md` rubrics. |
| `scenarios/` | Rubrics | Three test scenarios: loop discipline, agentic efficiency, visioner format. |
| `scripts/validate.sh` | Check | Validates the frontmatter of all skills and agent files. |

## The pipeline

The four agents form a chain — each output is the next agent's input:

```
visioner → planner → implementer → reviewer
```

- **visioner** turns a vague goal into a Vision Brief.
- **planner** turns the brief into an ordered, verifiable Implementation Plan.
- **implementer** executes the plan one step per iteration under the `loop` skill, with evidence.
- **reviewer** audits the result against the plan's acceptance criteria before it counts as done.

The discipline skills apply throughout: `agentic` (how to work), `loop` (how
to finish), `security` (what must never break).

## Why these skills (tested, not vibes)

Each skill was tested RED-vs-GREEN: the same task executed twice by identical
coding agents — once without the skill (RED), once with it (GREEN) — on an
isolated fixture containing a hidden root-cause bug, a failing test suite,
a crashing CLI path, and scope-creep bait. Results below were verified
forensically on the filesystem (test runs, CLI behavior, diffs), not taken
from agent self-reports.

| Skill | Measured advantage over the no-skill baseline |
|-------|-----------------------------------------------|
| `agentic` | Same quality with **~55% fewer tokens** (190k vs 427k) and fewer iterations (10 vs 16); plus documented exit-code contract in the README of the fixed project. |
| `loop` | Verification moved from end-loaded to per-criterion: the checklist caught the agent's own invalid verification mid-run, and a mutation check (re-introduce the bug → tests fail → restore) proved the new tests actually guard the regression. |
| `visioner` | Baseline produced good-but-unexecutable advice; with the agent, output followed the full Vision Brief — measurable north star with baseline, 5 non-goals, 3 kill criteria, an M0 that attacks the riskiest assumption, and acceptance criteria an agent can check. |

Across all arms, the coding agents found the root cause hiding deeper than the
reported symptom, left the test suite green, and refused the scope-creep bait.

*Caveat: single-run smoke test per arm — directional evidence, not a full
benchmark.*

## Install (Claude Code)

```bash
git clone https://github.com/marcelinobuilera-create/agentic-skills.git
./agentic-skills/scripts/install.sh --dry-run   # preview
./agentic-skills/scripts/install.sh             # skills → ~/.claude/skills, agents → ~/.claude/agents
```

Other runtimes (Codex, Copilot CLI, Gemini CLI) recognize `~/.agents/skills/`
as a cross-runtime location — point the installer there instead:
`./scripts/install.sh --skills-dir ~/.agents/skills --agents-dir ~/.agents/agents`.

## Usage

- Skills load automatically when the situation matches their description.
- Agents are invoked as subagents, e.g. *"Use the visioner agent on this idea: ..."*
  or *"Have the planner break this down, then the implementer execute it, then the
  reviewer audit it against the plan."*

## Validate & eval

```bash
./scripts/validate.sh                    # frontmatter check for every skill and agent
./scripts/eval.sh list                   # list test scenarios
./scripts/eval.sh run visioner-format    # generate RED/GREEN prompts, grade outputs against the rubric
```
