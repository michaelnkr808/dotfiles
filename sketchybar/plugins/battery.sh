#!/bin/sh
# Battery indicator with evergarden palette.

ICON_FULL=$(printf '\xef\x89\x80')      # U+F240
ICON_HIGH=$(printf '\xef\x89\x81')      # U+F241
ICON_HALF=$(printf '\xef\x89\x82')      # U+F242
ICON_LOW=$(printf '\xef\x89\x83')       # U+F243
ICON_EMPTY=$(printf '\xef\x89\x84')     # U+F244
ICON_CHARGING=$(printf '\xef\x87\xa6')  # U+F1E6  plug

PERCENTAGE="$(pmset -g batt | grep -Eo "\d+%" | cut -d% -f1)"
CHARGING="$(pmset -g batt | grep 'AC Power')"

if [ "$PERCENTAGE" = "" ]; then
  exit 0
fi

case "${PERCENTAGE}" in
  9[0-9]|100)  ICON="$ICON_FULL";  COLOR=0xff81a1c1 ;;
  [6-8][0-9])  ICON="$ICON_HIGH";  COLOR=0xff81a1c1 ;;
  [3-5][0-9])  ICON="$ICON_HALF";  COLOR=0xffebcb8b ;;
  [1-2][0-9])  ICON="$ICON_LOW";   COLOR=0xffbf616a ;;
  *)           ICON="$ICON_EMPTY"; COLOR=0xffbf616a ;;
esac

if [ "$CHARGING" != "" ]; then
  ICON="$ICON_CHARGING"
  COLOR=0xff81a1c1
fi

sketchybar --set "$NAME" icon="$ICON" icon.color="$COLOR" label="${PERCENTAGE}%"
