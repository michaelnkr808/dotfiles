#!/bin/bash
# Network speed plugin. Pass "up" or "down" as $1.
# Diffs interface byte counters between calls (cached in /tmp) to compute KB/s.
# Animates icon color: dim when idle, bright + slightly larger when traffic spikes.

DIRECTION="$1"
INTERFACE="en0"
CACHE="/tmp/sketchybar_net_${INTERFACE}"

ICON_DOWN=$(printf '\xef\x81\xa3')
ICON_UP=$(printf '\xef\x81\xa2')

STATS=$(netstat -ib | awk -v iface="$INTERFACE" '$1 == iface { print $7, $10; exit }')
CUR_RX=$(echo "$STATS" | awk '{print $1}')
CUR_TX=$(echo "$STATS" | awk '{print $2}')
NOW=$(date +%s)

[ -z "$CUR_RX" ] && CUR_RX=0
[ -z "$CUR_TX" ] && CUR_TX=0

RX_RATE=0
TX_RATE=0

if [ -f "$CACHE" ]; then
  LAST_RX=$(awk 'NR==1' "$CACHE")
  LAST_TX=$(awk 'NR==2' "$CACHE")
  LAST_TIME=$(awk 'NR==3' "$CACHE")
  ELAPSED=$((NOW - LAST_TIME))
  if [ "$ELAPSED" -gt 0 ]; then
    RX_RATE=$(( (CUR_RX - LAST_RX) / ELAPSED ))
    TX_RATE=$(( (CUR_TX - LAST_TX) / ELAPSED ))
    [ "$RX_RATE" -lt 0 ] && RX_RATE=0
    [ "$TX_RATE" -lt 0 ] && TX_RATE=0
  fi
fi

printf '%s\n%s\n%s\n' "$CUR_RX" "$CUR_TX" "$NOW" > "$CACHE"

format_rate() {
  local rate=$1
  if [ "$rate" -gt 1048576 ]; then
    printf '%.1f MB/s' "$(echo "scale=1; $rate / 1048576" | bc)"
  elif [ "$rate" -gt 1024 ]; then
    printf '%d KB/s' "$((rate / 1024))"
  else
    printf '%d B/s' "$rate"
  fi
}

# Pick rate / icon based on direction
if [ "$DIRECTION" = "down" ]; then
  RATE=$RX_RATE
  ICON="$ICON_DOWN"
elif [ "$DIRECTION" = "up" ]; then
  RATE=$TX_RATE
  ICON="$ICON_UP"
else
  exit 0
fi

LABEL=$(format_rate "$RATE")

# Brighten when traffic > 100 KB/s, otherwise dim resting color
if [ "$RATE" -gt 102400 ]; then
  COLOR=0xff88c0d0     # bright accent
  SIZE=14
else
  COLOR=0xff81a1c1     # resting evergarden green
  SIZE=13
fi

sketchybar --animate sin 12 --set "$NAME" \
  icon="$ICON" \
  icon.color="$COLOR" \
  icon.font="JetBrainsMono Nerd Font:Bold:${SIZE}.0" \
  label="$LABEL"
