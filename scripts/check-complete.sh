#!/bin/sh

PLAN=$(ls -t .sisyphus/plans/*.md 2>/dev/null | head -1)

if [ -z "$PLAN" ]; then
    exit 0
fi

INCOMPLETE=$(grep -c '^\- \[ \]' "$PLAN" 2>/dev/null | tr -d '[:space:]')
[ -z "$INCOMPLETE" ] && INCOMPLETE=0

if [ "$INCOMPLETE" -gt 0 ]; then
    PLAN_NAME=$(basename "$PLAN")
    echo "[planning-hooks] INCOMPLETE: $INCOMPLETE tasks remaining in $PLAN_NAME"
    exit 1
fi

exit 0