# ASCII art clock widget — uses figlet for retro-terminal aesthetics.
# Refreshes every 30s (no second hand since the ASCII chars don't tick smoothly).

command: """
  /opt/homebrew/bin/figlet -f big -w 200 "$(/bin/date '+%l:%M %p')"
"""

refreshFrequency: 30000   # ms — every 30s

style: """
  position: absolute
  top: 60px
  left: 50%
  transform: translateX(-50%)
  font-family: 'JetBrainsMono Nerd Font Mono', monospace
  font-size: 18px
  font-weight: 700
  line-height: 1.0
  color: #81a1c1
  white-space: pre
  text-shadow: 0 0 24px rgba(129, 161, 193, 0.4), 0 0 4px rgba(129, 161, 193, 0.7)
  user-select: none
  letter-spacing: 1px
"""

render: (output) -> output

afterRender: -> # nothing extra needed
