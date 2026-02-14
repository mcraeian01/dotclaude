#!/usr/bin/env bash
# ~/.claude/scripts/daily-review.sh
# Collects activity since last run and writes a staging note to the Obsidian vault.
# Triggered by Claude Code session start hook.
# Review the output with /obsidian-review when ready.

set -euo pipefail

TIMESTAMP_FILE="$HOME/.claude/scripts/.last-review"
VAULT="$HOME/Documents/Obsidian/homelab"
REVIEW_FILE="$VAULT/daily-review-log.md"
NOW=$(date +%s)
NOW_HUMAN=$(date '+%Y-%m-%d %H:%M')

# ── Only run once per day ──────────────────────────────────────────────────────
if [[ -f "$TIMESTAMP_FILE" ]]; then
  LAST=$(cat "$TIMESTAMP_FILE")
  ELAPSED=$(( NOW - LAST ))
  if [[ $ELAPSED -lt 86400 ]]; then
    exit 0  # Already ran today, stay silent
  fi
fi

# ── Determine diff window ──────────────────────────────────────────────────────
if [[ -f "$TIMESTAMP_FILE" ]]; then
  SINCE=$(date -d "@$(cat "$TIMESTAMP_FILE")" '+%Y-%m-%d %H:%M' 2>/dev/null \
    || date -r "$(cat "$TIMESTAMP_FILE")" '+%Y-%m-%d %H:%M')
else
  SINCE="24 hours ago"
fi

# ── Collect activity ───────────────────────────────────────────────────────────
ACTIVITY=""

# 1. ~/.claude/ changes (skills, commands, agents)
CLAUDE_CHANGES=$(find "$HOME/.claude" \
  \( -name "*.md" -o -name "*.json" -o -name "*.sh" \) \
  -newer "$TIMESTAMP_FILE" 2>/dev/null || true)

if [[ -n "$CLAUDE_CHANGES" ]]; then
  ACTIVITY+="### ~/.claude/ changes\n\n"
  while IFS= read -r line; do
    ACTIVITY+="- \`$line\`\n"
  done <<< "$CLAUDE_CHANGES"
  ACTIVITY+="\n"
fi

# 2. Git activity across home directory repos
GIT_ACTIVITY=""
while IFS= read -r -d '' repo; do
  REPO_DIR=$(dirname "$repo")
  REPO_NAME=$(basename "$REPO_DIR")
  COMMITS=$(git -C "$REPO_DIR" log \
    --since="$SINCE" \
    --oneline \
    --no-merges \
    2>/dev/null || true)
  if [[ -n "$COMMITS" ]]; then
    GIT_ACTIVITY+="#### $REPO_NAME\n\n"
    while IFS= read -r commit; do
      GIT_ACTIVITY+="- $commit\n"
    done <<< "$COMMITS"
    GIT_ACTIVITY+="\n"
  fi
done < <(find "$HOME" -maxdepth 5 -name ".git" -type d -print0 \
  -not -path "*/node_modules/*" \
  -not -path "*/.cache/*" \
  -not -path "*/.local/share/nvim/*" \
  2>/dev/null)

if [[ -n "$GIT_ACTIVITY" ]]; then
  ACTIVITY+="### Git commits\n\n$GIT_ACTIVITY"
fi

# 3. Pacman package activity
PKG_ACTIVITY=$(awk -v since="[$SINCE]" '$0 >= since' /var/log/pacman.log 2>/dev/null \
  | grep -i "installed\|removed\|upgraded" \
  | tail -50 || true)

if [[ -n "$PKG_ACTIVITY" ]]; then
  ACTIVITY+="### Packages\n\n"
  while IFS= read -r line; do
    ACTIVITY+="- \`$line\`\n"
  done <<< "$PKG_ACTIVITY"
  ACTIVITY+="\n"
fi

# ── Bail early if nothing to report ───────────────────────────────────────────
if [[ -z "$ACTIVITY" ]]; then
  echo "$NOW" > "$TIMESTAMP_FILE"
  exit 0
fi

# ── Build the new entry ────────────────────────────────────────────────────────
NEW_ENTRY="## $NOW_HUMAN\n\n${ACTIVITY}---\n\n_Review with \`/obsidian-review\` or update notes manually._\n\n---\n\n"

# ── Create file with frontmatter if it doesn't exist ──────────────────────────
if [[ ! -f "$REVIEW_FILE" ]]; then
  cat > "$REVIEW_FILE" << 'EOF'
---
title: Daily Review Log
tags: [daily-review, homelab, claude, activity-log]
type: homelab
---

# Daily Review Log

Activity log generated at each Claude CLI session start. Review entries and update relevant notes using `/obsidian-review` or `/obsidian`.

---

EOF
fi

# ── Prepend new entry — header stays, new content goes right after ─────────────
TMPFILE=$(mktemp)

# Write everything up to and including the first "---" separator after the header
awk '/^---$/{count++; print; if(count==3){exit} next} {print}' "$REVIEW_FILE" > "$TMPFILE"

# Append the new entry
echo -e "\n$NEW_ENTRY" >> "$TMPFILE"

# Append everything after the header from the original file
awk '/^---$/{count++} count==3{found=1; next} found{print}' "$REVIEW_FILE" >> "$TMPFILE"

mv "$TMPFILE" "$REVIEW_FILE"

# ── Update timestamp ───────────────────────────────────────────────────────────
echo "$NOW" > "$TIMESTAMP_FILE"

# ── Notify in terminal ─────────────────────────────────────────────────────────
echo ""
echo "📓 Daily review written to Obsidian — run /obsidian-review to action it."
echo ""
