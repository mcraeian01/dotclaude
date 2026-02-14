---
name: commit-conventions
description: Git commit and PR conventions — loads automatically when Claude is writing commit messages, creating branches, drafting PR descriptions, or doing anything git-related. Ensures consistent formatting without needing to re-specify preferences.
---

# Git Conventions

Apply these conventions whenever touching version control — commits, branches, PRs, or changelogs.

## Commit messages

Use the Conventional Commits format:

```
<type>(<scope>): <short summary>

<optional body>

<optional footer>
```

**Types:** `feat`, `fix`, `refactor`, `chore`, `docs`, `test`, `perf`, `ci`

**Rules:**
- Summary line: imperative mood, lowercase, no period, max 72 characters ("add retry logic" not "Added retry logic")
- Body: explain *why*, not *what* — the diff already shows what changed
- One logical change per commit — if a commit message needs "and", it should probably be two commits
- Reference issue numbers in the footer: `Closes #42`

## Branch names

```
<type>/<short-description>
```

Examples: `feat/user-auth`, `fix/null-pointer-login`, `chore/update-deps`

Lowercase, hyphens only, no more than 4-5 words.

## PR descriptions

Structure every PR description with:
1. **What** — one sentence on what changed
2. **Why** — the motivation or problem being solved
3. **How** — a brief note on the approach taken, especially if non-obvious
4. **Testing** — how the change was verified
5. **Links** — related issues, tickets, or prior PRs

Keep it scannable. Reviewers should understand the PR in under 60 seconds.
