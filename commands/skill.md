---
description: Generates a new Claude Code skill from a description and local context. Pass a name and description of what the skill should do.
argument-hint: [skill-name] [description of what it should do]
allowed-tools: Read, Glob, Bash(find:*), Bash(ls:*), Bash(mkdir:*), Bash(cat:*)
disable-model-invocation: true
---

# Skill Generator

You are generating a new Claude Code skill. The user has requested:

**Input:** $ARGUMENTS

Parse the input to extract:
1. The desired skill name (first word or hyphenated phrase before a space)
2. A description of what the skill should do (the rest of the arguments)

If arguments are ambiguous or missing, ask for clarification before proceeding.

---

## Step 1 — Gather Local Context

Before writing anything, scan the project to understand the environment this skill will live in.

Run the following in sequence:

1. `find . -name "SKILL.md" -not -path "*/node_modules/*"` — see if any skills already exist and inspect their structure for conventions
2. `ls .claude/skills/ 2>/dev/null || ls ~/.claude/skills/ 2>/dev/null` — list existing skills to avoid name conflicts
3. `cat CLAUDE.md 2>/dev/null || cat .claude/CLAUDE.md 2>/dev/null` — read any project-level preferences
4. Check the current file or recent conversation context for domain-specific terminology, tech stack, or patterns relevant to the skill

Use what you find to inform the skill's tone, vocabulary, tool choices, and scope. A skill for a Python data science repo should look different from one for a TypeScript web app.

---

## Step 2 — Design the Skill

Before writing the SKILL.md, reason through the following:

- **What is the single job of this skill?** Don't overload it. One skill, one responsibility.
- **When should Claude invoke it automatically?** Write the description to trigger on the right keywords and contexts.
- **Should the user control invocation?** If the skill has side effects (writes files, runs commands, sends requests), set `disable-model-invocation: true`.
- **What tools does it need?** Only request tools that are actually required — don't give broad permissions by default.
- **Does it need supporting files?** If the instructions would exceed ~200 lines, plan for a `references/` file instead of bloating SKILL.md.

---

## Step 3 — Write the Skill

Create the skill directory and SKILL.md at `~/.claude/skills/<skill-name>/SKILL.md` (personal, available across all projects) unless the user or local context suggests it should be project-scoped (`.claude/skills/<skill-name>/SKILL.md`).

The SKILL.md must follow this exact structure:

```
---
name: <skill-name>          # max 64 chars, lowercase, hyphens only
description: <description>  # max 1024 chars — this is what Claude sees at startup
                             # Include: what it does AND when to invoke it
                             # Do NOT include "when to use" sections in the body
                             # (the body only loads AFTER the skill is already chosen)
allowed-tools: <tools>      # only if needed: Read, Bash(...), Write, etc.
disable-model-invocation: true  # include only if the skill has side effects
---

# <Skill Title>

<One sentence on what this skill does and why it exists>

## <Core Section>

<Instructions for Claude. Be specific and procedural. Avoid vague guidance like
"be helpful" — instead say exactly what to do, in what order, with what output.>

## <Additional Sections as needed>

<Keep total body under 500 lines. If more detail is needed, reference a
`references/detail.md` file and note it here.>
```

---

## Step 4 — Output and Confirm

After creating the file:

1. Print the full contents of the generated SKILL.md for review
2. State the exact path where it was written
3. Tell the user how to invoke it: `/skill-name` or describe the auto-invocation trigger
4. Suggest one follow-up improvement or optional supporting file that would make it more powerful

Do not silently create files — always show the user what was written and where.
