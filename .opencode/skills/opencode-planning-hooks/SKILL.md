---
name: opencode-planning-hooks
description: Planning hooks to track active plan state, show task progress, and verify completion before session ends
version: 1.0.0
author: opencode
type: skill
category: planning
tags:
  - planning
  - hooks
  - task-tracking
  - sisyphus
hooks:
  - name: UserPromptSubmit
    matcher: ""
    inline: |
      PLAN=$(ls -t .sisyphus/plans/*.md 2>/dev/null | head -1)
      if [ -n "$PLAN" ]; then
        PLAN_NAME=$(basename "$PLAN")
        DONE=$(grep -c '\- \[[ xX]\]' "$PLAN" 2>/dev/null || echo 0)
        TOTAL=$(grep -c '\- \[ \]' "$PLAN" 2>/dev/null || echo 0)
        TOTAL=$((DONE + TOTAL))
        echo "[planning-hooks] Active plan: $PLAN_NAME | Tasks: $DONE/$TOTAL"
      fi
    description: On every user message, show active plan state
  - name: PreToolUse
    matcher: Write|Edit|Bash|Read|Glob|Grep
    inline: |
      PLAN=$(ls -t .sisyphus/plans/*.md 2>/dev/null | head -1)
      if [ -n "$PLAN" ]; then
        head -5 "$PLAN" 2>/dev/null
      fi
    description: Re-read plan before tool calls
  - name: PostToolUse
    matcher: Write|Edit
    inline: |
      PLAN=$(ls -t .sisyphus/plans/*.md 2>/dev/null | head -1)
      if [ -n "$PLAN" ]; then
        PLAN_NAME=$(basename "$PLAN")
        echo "[planning-hooks] Plan $PLAN_NAME active — update task status if work completed."
      fi
    description: Remind to update plan after writes
  - name: Stop
    matcher: ""
    inline: |
      if [ -f "scripts/check-complete.sh" ]; then
        RESULT=$(bash scripts/check-complete.sh 2>/dev/null)
        if [ -n "$RESULT" ]; then
          echo "$RESULT"
        fi
      fi
    description: Verify completion before session ends
---

# Planning Hooks Skill

> **Purpose**: Provide lightweight planning hooks to keep the active plan visible throughout the session without polluting context.

---

## What I Do

These hooks serve as attention directors:
- **UserPromptSubmit**: Shows active plan and task progress on each user message
- **PreToolUse**: Displays plan title + TL;DR before editing/writing tools
- **PostToolUse**: Reminds to update task status after writes
- **Stop**: Runs completion check before session ends

---

## How It Works

All hooks automatically find the most recently modified plan in `.sisyphus/plans/*.md` using `ls -t`. If no plan exists, hooks produce no output (silent skip).

### Active Plan Detection

```bash
PLAN=$(ls -t .sisyphus/plans/*.md 2>/dev/null | head -1)
```

### Task Counting

```bash
DONE=$(grep -c '\- \[[ xX]\]' "$PLAN" 2>/dev/null || echo 0)
TOTAL=$(grep -c '\- \[ \]' "$PLAN" 2>/dev/null || echo 0)
```

---

## Notes

- Hooks are read-only — they never mutate plan files
- All error output is silenced with `2>/dev/null`
- Hook output is capped at 5 lines to prevent context pollution
- Uses POSIX-compatible shell commands (no bashisms)