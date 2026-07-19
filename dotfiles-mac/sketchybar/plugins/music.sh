#!/bin/sh
# Currently playing music from Spotify or Apple Music.

ICON_SPOTIFY=$(printf '\xef\x86\xbc')   # U+F1BC  spotify
ICON_MUSIC=$(printf '\xef\x80\x81')     # U+F001  music note

get_track() {
  local app="$1"
  osascript <<EOF 2>/dev/null
    if application "$app" is running then
      tell application "$app"
        if player state is playing then
          return (artist of current track) & " - " & (name of current track)
        end if
      end tell
    end if
EOF
}

SPOTIFY=$(get_track "Spotify")
MUSIC=$(get_track "Music")

if [ -n "$SPOTIFY" ]; then
  TRACK="$SPOTIFY"
  ICON="$ICON_SPOTIFY"
elif [ -n "$MUSIC" ]; then
  TRACK="$MUSIC"
  ICON="$ICON_MUSIC"
else
  TRACK=""
fi

if [ -n "$TRACK" ]; then
  if [ ${#TRACK} -gt 40 ]; then
    TRACK="${TRACK:0:37}..."
  fi
  sketchybar --set "$NAME" drawing=on icon="$ICON" icon.color=0xff81a1c1 label="$TRACK"
else
  sketchybar --set "$NAME" drawing=off
fi
