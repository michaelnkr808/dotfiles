# Basic Nord clock — big translucent time + date.
# Big thin Frost-blue numerals, slate-gray date label below.

command: "/bin/date '+%-I:%M %p|%A, %b %-d'"

refreshFrequency: 1000

render: (output) ->
  [time, date] = output.trim().split('|')
  """
    <div class="time">#{time}</div>
    <div class="date">#{date}</div>
  """

style: """
  position: absolute
  top: 100px
  left: 50%
  transform: translateX(-50%)
  font-family: 'JetBrainsMono Nerd Font', monospace
  text-align: center
  user-select: none

  .time
    font-size: 96px
    font-weight: 200
    letter-spacing: 4px
    color: #81a1c1
    text-shadow: 0 0 60px rgba(129, 161, 193, 0.35), 0 0 8px rgba(129, 161, 193, 0.5)
    line-height: 1.0

  .date
    font-size: 22px
    font-weight: 600
    color: #d8dee9
    letter-spacing: 6px
    text-transform: uppercase
    margin-top: 18px
    text-shadow: 0 0 12px rgba(216, 222, 233, 0.3)
"""
