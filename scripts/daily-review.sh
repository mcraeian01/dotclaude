#!/usr/bin/env bash
# ~/.claude/scripts/daily-review.sh
# Collects activity since last run and calls Claude for Obsidian suggestions.
# Triggered by Claude Code session start hook.

set -euo pipefail

TIMESTAMP_FILE="$HOME/.claude/scripts/.last-review"
VAULT="$HOME/Documents/Obsidian/homelab"
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

echo ""
echo "┌─────────────────────────────────────────────────┐"
echo "│  📓 Daily Obsidian Review — $NOW_HUMAN  │"
echo "└─────────────────────────────────────────────────┘"
echo ""

# ── Determine diff window ──────────────────────────────────────────────────────
if [[ -f "$TIMESTAMP_FILE" ]]; then
  LAST_DATE=$(date -d "@$(cat "$TIMESTAMP_FILE")" '+%Y-%m-%d %H:%M' 2>/dev/null \
    || date -r "$(cat "$TIMESTAMP_FILE")" '+%Y-%m-%d %H:%M')  # macOS fallback
else
  LAST_DATE="24 hours ago"
fi

SINCE="$LAST_DATE"

# ── Collect activity ───────────────────────────────────────────────────────────
ACTIVITY=""

# 1. ~/.claude/ changes (skills, commands, agents)
CLAUDE_CHANGES=$(find "$HOME/.claude" \
  -name "*.md" -o -name "*.json" -o -name "*.sh" \
  | xargs ls -lt 2>/dev/null \
  | awk -v since="$SINCE" 'NR>1 && $0 > since {print}' \
  || true)

if [[ -n "$CLAUDE_CHANGES" ]]; then
  ACTIVITY+="## ~/.claude/ changes since last review\n"
  ACTIVITY+="$(find "$HOME/.claude" \( -name "*.md" -o -name "*.json" -o -name "*.sh" \) \
    -newer "$TIMESTAMP_FILE" 2>/dev/null || \
    find "$HOME/.claude" \( -name "*.md" -o -name "*.json" -o -name "*.sh" \) \
    -mtime -1 2>/dev/null)\n\n"
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
    GIT_ACTIVITY+="### $REPO_NAME\n$COMMITS\n\n"
  fi
done < <(find "$HOME" -maxdepth 4 -name ".git" -type d -print0 \
  -not -path "*/node_modules/*" \
  -not -path "*/.cache/*" \
  2>/dev/null)

if [[ -n "$GIT_ACTIVITY" ]]; then
  ACTIVITY+="## Git commits since last review\n$GIT_ACTIVITY"
fi

# 3. System logs / installed packages
PKG_ACTIVITY=""

# pacman (Debian/Ubuntu)
if command -v pacman &>/dev/null; then
  PKG_ACTIVITY+=$(grep -i "install\|remove\|upgrade" /var/log/pacman/history.log 2>/dev/null \
    | tail -50 || true)
fi

# pacman (Arch)
if command -v pacman &>/dev/null; then
  PKG_ACTIVITY+=$(grep -i "installed\|removed\|upgraded" /var/log/pacman.log 2>/dev/null \
    | tail -50 || true)
fi

# systemd service changes
SYSTEMD_CHANGES=$(systemctl list-units --state=active --type=service \
  --no-legend 2>/dev/null | head -30 || true)

if [[ -n "$PKG_ACTIVITY" ]] || [[ -n "$SYSTEMD_CHANGES" ]]; then
  ACTIVITY+="## System activity since last review\n"
  [[ -n "$PKG_ACTIVITY" ]] && ACTIVITY+="### Packages\n$PKG_ACTIVITY\n\n"
  [[ -n "$SYSTEMD_CHANGES" ]] && ACTIVITY+="### Active services snapshot\n$SYSTEMD_CHANGES\n\n"
fi

# 4. Existing vault notes (for link suggestions)
VAULT_INDEX=$(find "$VAULT" -name "*.md" -not -path "*/.obsidian/*" \
  | sed "s|$VAULT/||" | sort 2>/dev/null || true)

# ── Bail early if nothing to report ───────────────────────────────────────────
if [[ -z "$ACTIVITY" ]]; then
  echo "No significant activity detected since last review. Vault looks up to date."
  echo "$NOW" > "$TIMESTAMP_FILE"
  exit 0
fi

# ── Call Claude non-interactively ──────────────────────────────────────────────
PROMPT=$(cat <<EOF
Use the /obsidian-review command with this context:

LAST REVIEW: $SINCE
VAULT NOTES:
$VAULT_INDEX

ACTIVITY:
$ACTIVITY
EOF
)

echo "$PROMPT" | claude --print /obsidian-review

# ── Update timestamp ───────────────────────────────────────────────────────────
echo "$NOW" > "$TIMESTAMP_FILE"
