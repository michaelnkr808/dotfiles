#!/bin/bash
# Workspace pill — reads cached workspace→app map for snappy renders.
# The cache is refreshed once per workspace change by update_spaces.sh,
# which means each pill avoids spawning its own aerospace subprocess.

SID="${NAME##*.}"
CACHE=/tmp/sketchybar_ws_apps.cache

# FOCUSED workspace — trust the env var (set by the trigger). If for some
# reason it's missing (e.g. forced --update from elsewhere), fall back to CLI.
FOCUSED="$FOCUSED_WORKSPACE"
if [ -z "$FOCUSED" ]; then
  FOCUSED=$(aerospace list-workspaces --focused 2>/dev/null)
fi

get_icon() {
  case "$1" in
    "kitty"|"Terminal"|"iTerm2"|"iTerm"|"Alacritty"|"WezTerm")
      printf '\xef\x84\xa0' ;;
    "Firefox"|"Firefox Developer Edition")
      printf '\xef\x89\xa9' ;;
    "Safari"|"Safari Technology Preview")
      printf '\xef\x89\xa7' ;;
    "Google Chrome"|"Chrome"|"Brave Browser"|"Arc")
      printf '\xef\x89\xa8' ;;
    "Slack")                          printf '\xef\x86\x98' ;;
    "Discord")                        printf '\xf3\xb0\x99\xaf' ;;   # nf-md-discord U+F066F (fa-brand U+F392 is missing from JetBrainsMono NF)
    "Spotify")                        printf '\xef\x86\xbc' ;;
    "Music"|"Apple Music")            printf '\xef\x80\x81' ;;
    "Mail")                           printf '\xef\x83\xa0' ;;
    "Calendar")                       printf '\xef\x81\xb3' ;;
    "Finder")                         printf '\xef\x81\xbb' ;;
    "Notes"|"Notion"|"Obsidian")      printf '\xef\x86\x9c' ;;
    "Figma"|"Sketch")                 printf '\xef\x9d\xb1' ;;
    "Cursor"|"Visual Studio Code"|"Code"|"Zed"|"Neovide")
      printf '\xef\x84\xa1' ;;
    "Claude"|"ChatGPT")               printf '\xef\x82\x86' ;;
    "Messages")                       printf '\xef\x81\xb5' ;;
    *)                                printf '\xef\x83\x88' ;;
  esac
}

# Read cached apps for THIS workspace from the shared cache file.
# Format per line: "workspace_id|app-name"
APP_ICONS=""
SEEN=""
if [ -f "$CACHE" ]; then
  while IFS='|' read -r ws app; do
    [ "$ws" != "$SID" ] && continue
    [ -z "$app" ] && continue
    case " $SEEN " in *" $app "*) continue ;; esac
    SEEN="$SEEN $app"
    APP_ICONS="$APP_ICONS$(get_icon "$app") "
  done < "$CACHE"
fi
APP_ICONS="${APP_ICONS% }"

# Determine target state
if [ "$SID" = "$FOCUSED" ]; then
  STATE="active"
elif [ -n "$APP_ICONS" ]; then
  STATE="windowed"
else
  STATE="empty"
fi

# Skip if visual state didn't change
STATE_FILE="/tmp/sketchybar_space_${SID}.state"
NEW_STATE="${STATE}|${APP_ICONS}"
if [ -f "$STATE_FILE" ] && [ "$(cat "$STATE_FILE")" = "$NEW_STATE" ]; then
  exit 0
fi
echo "$NEW_STATE" > "$STATE_FILE"

case "$STATE" in
  active)
    sketchybar --animate tanh 14 --set "$NAME" \
      icon="$SID" \
      label="$APP_ICONS" \
      label.drawing=on \
      background.drawing=on \
      background.color=0xff81a1c1 \
      background.corner_radius=13 \
      background.height=28 \
      background.border_color=0xff81a1c1 \
      background.border_width=0 \
      icon.color=0xff2e3440 \
      label.color=0xff2e3440 \
      icon.padding_left=12 \
      label.padding_right=12 \
      icon.font="JetBrainsMono Nerd Font:Bold:13.0"
    ;;
  windowed)
    sketchybar --animate tanh 14 --set "$NAME" \
      icon="$SID" \
      label="$APP_ICONS" \
      label.drawing=on \
      background.drawing=on \
      background.color=0x14ffffff \
      background.corner_radius=10 \
      background.height=24 \
      background.border_color=0x3381a1c1 \
      background.border_width=1 \
      icon.color=0xffd8dee9 \
      label.color=0xff81a1c1 \
      icon.padding_left=10 \
      label.padding_right=10 \
      icon.font="JetBrainsMono Nerd Font:Semibold:13.0"
    ;;
  empty)
    sketchybar --animate tanh 14 --set "$NAME" \
      icon="$SID" \
      label="" \
      label.drawing=off \
      background.drawing=on \
      background.color=0x00000000 \
      background.corner_radius=10 \
      background.height=24 \
      background.border_width=0 \
      icon.color=0xff4c566a \
      icon.padding_left=10 \
      icon.padding_right=10 \
      icon.font="JetBrainsMono Nerd Font:Semibold:13.0"
    ;;
esac
