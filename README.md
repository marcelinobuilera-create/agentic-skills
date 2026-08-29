# Agentic Skills

A collection of agent skills and one agent definition, written in the
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
| `scripts/validate.sh` | Check | Validates the frontmatter of all skills and the agent file. |

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
mkdir -p ~/.claude/skills ~/.claude/agents
cp -r agentic-skills/skills/agentic agentic-skills/skills/loop ~/.claude/skills/
cp agentic-skills/agents/visioner.md ~/.claude/agents/
```

Other runtimes (Codex, Copilot CLI, Gemini CLI) also recognize `~/.agents/skills/`
as a cross-runtime location — copy the skill folders there instead if you prefer.

## Usage

- **agentic** — loads when the agent is executing multi-step work autonomously.
- **loop** — loads when a task needs an explicit act/verify cycle with exit criteria.
- **visioner** — invoke as a subagent, e.g. *"Use the visioner agent on this idea: ..."*

## Validate

```bash
./scripts/validate.sh
```
