#!/bin/sh
# Unread GitHub notification count via `gh` CLI.
# Requires:  brew install gh && gh auth login

ICON=$(printf '\xef\x82\x9b')   # U+F09B  github

GH=/opt/homebrew/bin/gh

if [ ! -x "$GH" ]; then
  sketchybar --set "$NAME" drawing=off
  exit 0
fi

COUNT=$("$GH" api notifications --jq 'length' 2>/dev/null)

if [ -z "$COUNT" ]; then
  sketchybar --set "$NAME" drawing=off
  exit 0
fi

if [ "$COUNT" -eq 0 ]; then
  COLOR=0xff616e88
else
  COLOR=0xff81a1c1
fi

sketchybar --set "$NAME" drawing=on icon="$ICON" icon.color="$COLOR" label="$COUNT"
