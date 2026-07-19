# ASCII bonsai — runs cbonsai inside a headless tmux pane (so we can capture
# the final rendered grid as plain text — cbonsai's stdout uses ncurses cursor
# positioning that isn't pasteable into HTML). Seeded with day-of-year so the
# tree is the same all day, regrown daily.

command: """
  SEED=$(/bin/date '+%j')
  SESSION="ubersicht-bonsai-$$"
  /opt/homebrew/bin/tmux new-session -d -s "$SESSION" -x 50 -y 22 \\
    "/opt/homebrew/bin/cbonsai -p -s $SEED -L 30 -M 6 -b 1; sleep 0.5" 2>/dev/null
  sleep 0.4
  /opt/homebrew/bin/tmux capture-pane -t "$SESSION" -p 2>/dev/null
  /opt/homebrew/bin/tmux kill-session -t "$SESSION" 2>/dev/null
"""

refreshFrequency: 86400000   # 24 hours

render: (output) -> "<pre>#{output}</pre>"

style: """
  position: absolute
  top: 270px
  left: 50%
  transform: translateX(-50%)
  font-family: 'JetBrainsMono Nerd Font Mono', 'Menlo', monospace
  font-size: 10px
  line-height: 1.0
  color: #88c0d0
  text-shadow: 0 0 5px rgba(136, 192, 208, 0.35)
  letter-spacing: 1px
  user-select: none
  pointer-events: none
  text-align: center

  pre
    margin: 0
    white-space: pre
    display: inline-block
"""
