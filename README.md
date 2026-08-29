# Agentic Skills

A small collection of agent skills and one agent definition, written in the
[Agent Skills](https://agentskills.io/specification) format (`SKILL.md` with
YAML frontmatter) so any compatible agent runtime can load them.

## Contents

| Path | Type | What it does |
|------|------|--------------|
| `skills/agentic/` | Skill | Operating principles for working agentically: orient first, act with the smallest change, verify with evidence, escalate on time. |
| `skills/loop/` | Skill | An explicit DEFINE → ACT → VERIFY → REPEAT loop with exit criteria, for running any non-trivial task to verified completion. |
| `agents/visioner.md` | Agent | A strategic "visioner" subagent that turns vague goals into a Vision Brief: problem, north star, non-goals, milestones with acceptance criteria, risks. |
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
