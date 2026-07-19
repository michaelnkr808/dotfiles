#!/bin/sh
# Shows active tmux sessions count + names. Hides when no sessions exist.

ICON=$(printf '\xef\x84\xa0')   # U+F120  terminal

# Use absolute path; sketchybar doesn't inherit shell PATH
TMUX=/opt/homebrew/bin/tmux

if [ ! -x "$TMUX" ]; then
  sketchybar --set "$NAME" drawing=off
  exit 0
fi

SESSIONS=$("$TMUX" ls 2>/dev/null | cut -d: -f1 | tr '\n' ' ' | sed 's/ $//')

if [ -z "$SESSIONS" ]; then
  sketchybar --set "$NAME" drawing=off
  exit 0
fi

COUNT=$(echo "$SESSIONS" | wc -w | tr -d ' ')

LABEL="$SESSIONS"
if [ ${#LABEL} -gt 28 ]; then
  LABEL="$COUNT sessions"
fi

sketchybar --set "$NAME" drawing=on icon="$ICON" icon.color=0xff81a1c1 label="$LABEL"
