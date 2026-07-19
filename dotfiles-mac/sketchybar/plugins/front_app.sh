#!/bin/sh
# Front app name — smooth label crossfade when the focused app changes.
# Single-phase, no entrance spring (was glitching on rapid app focus).

if [ "$SENDER" = "front_app_switched" ]; then
  sketchybar --animate tanh 12 --set "$NAME" \
    label="$INFO" \
    label.color=0xff81a1c1 \
    label.font="JetBrainsMono Nerd Font:Bold:13.0"
fi
