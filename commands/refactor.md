---
description: Structured refactoring workflow — understand intent first, identify issues, propose changes with rationale before touching anything. Pass a filename, a function name, or a description of what to refactor.
argument-hint: [file, function, or description]
allowed-tools: Read, Glob, Bash(find:*)
disable-model-invocation: true
---

# Refactor

The user wants to refactor: $ARGUMENTS

## Phase 1 — Understand before touching

Read the relevant code first. Do not suggest any changes yet.

After reading, answer these questions explicitly:
1. What is this code's current job?
2. What is it doing well?
3. What are the specific problems — clarity, structure, duplication, performance, or something else?

State your findings before moving on.

## Phase 2 — Propose, don't apply

Lay out what you'd change and why. For each proposed change:
- Describe the change in plain English
- Explain the specific problem it solves
- Note any tradeoffs or risks

Ask the user to confirm the direction before writing any new code.

## Phase 3 — Apply with explanation

Once confirmed, make the changes. For each change:
- Show the before and after
- Briefly restate the rationale

Make one logical change at a time. Don't bundle unrelated improvements into a single pass — if you notice something outside the agreed scope, flag it separately for a future refactor.
