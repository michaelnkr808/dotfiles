#!/bin/sh
# Combined user+system CPU percentage.

ICON=$(printf '\xef\x92\xbc')   # U+F4BC  microchip

CPU=$(top -l 1 | grep "CPU usage" | awk -F'[ ,%]' '{print int($3 + $6)}')

if [ -z "$CPU" ]; then
  exit 0
fi

if [ "$CPU" -ge 70 ]; then
  COLOR=0xffbf616a
elif [ "$CPU" -ge 40 ]; then
  COLOR=0xffebcb8b
else
  COLOR=0xff81a1c1
fi

sketchybar --set "$NAME" icon="$ICON" icon.color="$COLOR" label="${CPU}%"
