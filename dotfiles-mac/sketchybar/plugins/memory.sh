#!/bin/sh
# Memory used percentage.

ICON=$(printf '\xef\x87\x80')   # U+F1C0  database (stacked discs — distinct from microchip)

FREE=$(memory_pressure | grep "System-wide memory free percentage" | awk '{print $5}' | tr -d '%')

if [ -z "$FREE" ]; then
  exit 0
fi

USED=$((100 - FREE))

if [ "$USED" -ge 85 ]; then
  COLOR=0xffbf616a
elif [ "$USED" -ge 65 ]; then
  COLOR=0xffebcb8b
else
  COLOR=0xff81a1c1
fi

sketchybar --set "$NAME" icon="$ICON" icon.color="$COLOR" label="${USED}%"
