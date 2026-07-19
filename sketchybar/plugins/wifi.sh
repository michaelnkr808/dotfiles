#!/bin/sh
# WiFi state. On macOS Sonoma+, SSID is hidden ("<redacted>") unless the
# caller has Location services permission, which sketchybar doesn't.
# So: check connection state by whether en0 has an IPv4 address; show SSID
# when available, "on" when redacted, "off" when disconnected.

ICON_ON=$(printf '\xef\x87\xab')    # U+F1EB  wifi
ICON_OFF=$(printf '\xef\x82\xac')   # U+F0AC  globe (disconnected)

IPV4=$(ipconfig getifaddr en0 2>/dev/null)

if [ -z "$IPV4" ]; then
  # No IP means disconnected
  LABEL="off"
  ICON="$ICON_OFF"
  COLOR=0xff616e88
else
  # Connected. Try for SSID; fall back to "on" if hidden.
  SSID=$(ipconfig getsummary en0 2>/dev/null \
    | awk -F ' SSID : ' '/ SSID : / {print $2}' \
    | head -1 | sed 's/[[:space:]]*$//')

  if [ -z "$SSID" ] || [ "$SSID" = "<redacted>" ]; then
    LABEL="on"
  else
    LABEL="$SSID"
  fi

  ICON="$ICON_ON"
  COLOR=0xff81a1c1
fi

if [ ${#LABEL} -gt 20 ]; then
  LABEL="${LABEL:0:17}..."
fi

sketchybar --set "$NAME" icon="$ICON" icon.color="$COLOR" label="$LABEL"
