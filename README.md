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
