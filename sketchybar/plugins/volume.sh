#!/bin/sh
# Volume indicator. Dims when muted; warms slightly when low.

if [ "$SENDER" = "volume_change" ]; then
  VOLUME="$INFO"

  case "$VOLUME" in
    [6-9][0-9]|100)  ICON="󰕾"; COLOR=0xff81a1c1 ;;  # high
    [3-5][0-9])      ICON="󰖀"; COLOR=0xff81a1c1 ;;  # medium
    [1-9]|[1-2][0-9]) ICON="󰕿"; COLOR=0xffebcb8b ;;  # low
    *)               ICON="󰖁"; COLOR=0xff616e88 ;;  # muted, dimmed
  esac

  sketchybar --set "$NAME" icon="$ICON" icon.color="$COLOR" label="$VOLUME%"
fi
