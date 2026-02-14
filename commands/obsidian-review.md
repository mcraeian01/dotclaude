---
description: Analyzes activity since the last review and produces Obsidian vault update suggestions — existing note updates and new note candidates. Called by the daily-review.sh script at session start. Not intended for direct invocation.
allowed-tools: Read, Bash(find:*), Bash(cat:*)
disable-model-invocation: true
---

# Obsidian Daily Review

You have been given a summary of activity since the last review, and an index of existing vault notes. Your job is to produce clear, actionable suggestions for keeping the Obsidian vault current.

Do not write any files. Do not open Obsidian. Surface suggestions only — the user will act on them using `/obsidian` or manually.

---

## Step 1 — Parse the input

From the context provided, extract:
- What changed in `~/.claude/` (new skills, commands, agents, config)
- What was committed across git repos (read commit messages for intent, not just filenames)
- What packages were installed, removed, or upgraded
- Any systemd service changes that suggest new self-hosted infrastructure

Group related items together — a new skill added to `.claude` and commits to the same project are likely one story, not two separate ones.

---

## Step 2 — Match against the vault

For each activity cluster, check the vault index to determine:

**A) An existing note should be updated** — if the activity relates to something already documented, flag the specific note and describe what should be added or amended.

**B) A new note is warranted** — if the activity represents something not yet in the vault, suggest creating a new entry via `/obsidian <topic>`.

**C) Skip** — if the activity is trivial, automated, or already well-covered, don't surface it. Don't pad the list.

---

## Step 3 — Output suggestions

Format your response exactly like this — keep it tight and scannable:

---

### 📝 Notes to update

For each existing note that needs updating:

**[[Note Title]]**
> What to add: <1-2 sentences on what's missing and why it matters>
> Suggested [[links]] to add: <any newly relevant notes to cross-link>

---

### 🆕 New notes to create

For each topic worth a new entry:

**Suggested title:** `<note-title>`
> Why: <1 sentence on what happened and why it deserves a note>
> Run: `/obsidian <suggested topic description>`
> Likely links: [[<related existing note>]], [[<related existing note>]]

---

### ⏭ Skipped

Briefly list anything notable you saw but chose not to surface, and why. One line each. This keeps the review honest.

---

## Tone and length

- Be direct. No preamble, no "Great news!" — just the suggestions.
- If there's nothing worth surfacing, say so in one sentence and exit.
- The whole output should be readable in under 60 seconds.
