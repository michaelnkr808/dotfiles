#!/bin/sh
# Next upcoming calendar event with countdown.
# Requires: brew install ical-buddy

ICON=$(printf '\xef\x81\xb3')   # U+F073  calendar

ICALBUDDY=/opt/homebrew/bin/icalBuddy

if [ ! -x "$ICALBUDDY" ]; then
  sketchybar --set "$NAME" drawing=off
  exit 0
fi

# Fetch next 1 event today + tomorrow, formatted as: "HH:MM Title"
# We strip newlines and grab the first event line.
RAW=$("$ICALBUDDY" -nc -nrd -npn -eed -li 1 -df "" -tf "%H:%M" eventsToday+1 2>/dev/null)

if [ -z "$RAW" ]; then
  # nothing scheduled
  sketchybar --set "$NAME" drawing=on icon="$ICON" icon.color=0xff616e88 label="free"
  exit 0
fi

# Format from icalBuddy looks like:
#   Title!12:30 - 13:00
# We want: "12:30 Title"
TITLE=$(echo "$RAW" | head -1 | sed 's/!.*//')
TIME=$(echo "$RAW" | head -1 | sed 's/.*!\([0-9:]*\).*/\1/')

# Truncate long titles
if [ ${#TITLE} -gt 22 ]; then
  TITLE="${TITLE:0:19}..."
fi

LABEL="$TIME $TITLE"

sketchybar --set "$NAME" drawing=on icon="$ICON" icon.color=0xff81a1c1 label="$LABEL"
