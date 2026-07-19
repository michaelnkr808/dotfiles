#!/bin/bash
# Runs on every AeroSpace workspace change AND on a 5s timer (cache_refresher).
# Pre-computes the windows-per-workspace map, caches it, then triggers sketchybar.
# Each space.sh reads the cache instead of re-querying AeroSpace.
#
# The output is sorted so the cache is byte-stable across calls — without this,
# aerospace's window order can shuffle, the pill state hash flips on every
# refresh, and the bar visibly re-animates on each 5s tick.
# Timer ticks with unchanged content skip the trigger entirely to avoid churn.

CACHE=/tmp/sketchybar_ws_apps.cache
NEW=$(aerospace list-windows --all --format "%{workspace}|%{app-name}" 2>/dev/null | sort)

# Workspace switches always set AEROSPACE_FOCUSED_WORKSPACE. Timer ticks don't,
# so on a tick with no actual change, exit before firing the bar event.
if [ -z "$AEROSPACE_FOCUSED_WORKSPACE" ] && [ "$NEW" = "$(cat "$CACHE" 2>/dev/null)" ]; then
  exit 0
fi

printf '%s\n' "$NEW" > "$CACHE"
sketchybar --trigger aerospace_workspace_change FOCUSED_WORKSPACE="$AEROSPACE_FOCUSED_WORKSPACE"
