---
description: Summarizes the current state of a working session — what's been decided, what's still open, and what the next step is. Use in long sessions before context gets compressed, or any time you need to resurface shared understanding.
allowed-tools: Read
disable-model-invocation: true
---

# Session Checkpoint

Pause and produce a clear summary of where this session stands. Read any relevant open files for context if needed.

Output exactly this structure — keep each section tight:

---

## What we're doing
One or two sentences on the overall goal of this session.

## What's been decided
A short list of conclusions, choices, or implementations that are settled. These shouldn't be relitigated.

## What's still open
Questions, tradeoffs, or next steps that haven't been resolved yet. Be specific — "figure out auth" is too vague; "decide whether to use JWTs or sessions for the auth layer" is useful.

## Immediate next step
The single most logical thing to do next. One action, clearly stated.

---

After the summary, ask: "Does this match your understanding, or is anything missing?"
