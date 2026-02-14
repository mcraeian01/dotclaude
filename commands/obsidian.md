---
description: Drafts a new Obsidian note for the homelab vault at /home/voodoostix/Documents/Obsidian/homelab/. Scans the vault for related notes to suggest [[wikilinks]]. Always uses # headings and [[links]] for knowledge graph connectivity. This is an intentional action — only runs when explicitly invoked.
argument-hint: [topic or title of the note]
allowed-tools: Read, Bash(find:*), Bash(ls:*), Bash(cat:*), Write
disable-model-invocation: true
---

# Draft Obsidian Entry

The user wants to create a new note about: $ARGUMENTS

---

## Step 1 — Scan the vault

Before writing anything, explore the vault to understand what already exists.

Run:
```
find /home/voodoostix/Documents/Obsidian/homelab -name "*.md" -not -path "*/.obsidian/*"
```

From the file list:
- Identify notes whose titles or paths are semantically related to the topic
- These become candidates for `[[wikilinks]]` in the new entry
- Note any folder structure that suggests where this new entry belongs

Read 2-3 of the most relevant existing notes to understand the writing style, tag vocabulary, and link patterns already in use in this vault. Match them.

---

## Step 2 — Determine entry type

Based on the topic, classify it as one of:

- **Homelab** — infrastructure, configuration, services, hardware, networking, self-hosted tools
- **Learning** — concepts, explanations, references, research, insights

This determines which sections to include below.

---

## Step 3 — Draft the entry

Produce a complete Obsidian-ready markdown note using this structure:

---

```markdown
---
title: <Title>
date: <today's date as YYYY-MM-DD>
tags: [<2-4 lowercase tags relevant to the topic>]
type: <homelab | learning>
status: draft
---

# <Title>

## Summary
A 2-4 sentence overview of what this note covers and why it matters. Written in plain language — this is what you'll read when scanning the graph later.

## <Section A — varies by type>

### For homelab entries:
## Setup / Configuration
Step-by-step notes on what was done, commands run, or settings changed. Use code blocks for any commands, config snippets, or file paths.

## Why / Context
Why this change was made. What problem it solved, what was tried before, or what prompted it.

## Related Services
[[Link]] to any services, hosts, or configs this interacts with.

### For learning entries:
## Core Concept
The main idea explained clearly. Use analogies where helpful.

## Key Details
The specifics worth remembering — mechanisms, rules, exceptions.

## Questions / Open Threads
What's still unclear or worth exploring further.

---

## Links
- Related: [[<suggested note 1>]], [[<suggested note 2>]]
- See also: [[<any other relevant existing note>]]
```

---

## Step 4 — Heading and link rules

These are non-negotiable for vault health:

- **Always use `#` headings** — `#` for the title, `##` for sections, `###` for subsections. Never use bold text as a substitute for a heading.
- **Every note must link to at least 2 existing notes** using `[[wikilink]]` syntax. Orphan notes degrade the knowledge graph.
- **Link on first meaningful mention** — if a concept, service, or host has its own note, link it the first time it appears in the body, not just in the Links section.
- **Tags should be reused** where possible — scan existing notes and prefer tags already in the vault over inventing new ones.
- **Filenames** should be lowercase, hyphenated, matching the title: `my-note-title.md`

---

## Step 5 — Output and save

1. Print the full drafted note to the conversation for review
2. State the suggested file path (based on vault folder structure observed in Step 1)
3. Ask: "Does this look right, or would you like to adjust anything before I write the file?"
4. Only write the file after explicit confirmation — do not save automatically
