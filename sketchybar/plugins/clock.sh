#!/bin/sh
# Clock — abbreviated day + date + 12-hour time, like "Sun Jun 28 3:45 PM"
sketchybar --set "$NAME" label="$(date '+%a %b %d %l:%M %p')"
