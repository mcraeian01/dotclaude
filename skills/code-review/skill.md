---
name: code-review
description: Personal code review standards — loads automatically when Claude is reading, writing, or reviewing code. Applies consistent taste around readability, red flags, and tradeoffs without needing to re-explain preferences each session.
---

# Code Review Standards

When reviewing or writing code, apply these principles consistently.

## What to prioritize

- **Readability over cleverness** — if a simpler version exists, prefer it even if it's slightly more verbose
- **Explicit over implicit** — variable names, function names, and structure should make intent obvious without needing comments to explain *what* (comments should explain *why*)
- **Small, focused units** — functions and modules should do one thing; flag anything that's doing two or more distinct jobs
- **Fail loudly** — prefer errors that surface early and clearly over silent failures or ambiguous returns

## Red flags to call out

- Functions longer than ~40 lines without a clear reason
- Deeply nested conditionals (more than 2-3 levels)
- Magic numbers or strings with no named constant
- Mutable default arguments (especially in Python)
- Side effects in functions whose names suggest they're pure
- Overly broad exception handling (`except Exception`, `catch (e) {}`)
- Commented-out code left in without explanation

## How to deliver feedback

- Lead with what the code is doing well before flagging issues
- For each issue: state what it is, why it matters, and what a fix looks like
- Distinguish between *must fix* (correctness, security, significant maintainability risk) and *consider changing* (style, preference, minor improvement)
- Never rewrite large sections without explaining the reasoning — show the diff and the rationale together
