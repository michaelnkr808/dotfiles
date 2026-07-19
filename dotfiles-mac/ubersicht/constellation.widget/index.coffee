# Constellation overlay — 60 stars at golden-angle positions slowly rotate
# over 30 min, with 8 brighter Frost-cyan anchor stars connected by faint lines.
# Pure CSS animations, render runs once.

command: ""

refreshFrequency: false

render: ->
  cx = 300
  cy = 300

  # 60 scattered stars using golden angle for pleasing distribution
  stars = ""
  for i in [0...60]
    angle = (i * 137.508) * Math.PI / 180
    r = 80 + ((i * 17) % 220)
    x = cx + r * Math.cos(angle)
    y = cy + r * Math.sin(angle)
    size = 0.5 + ((i * 3) % 7) / 5
    delay = (i % 7) * 0.6
    stars += "<circle cx='#{x.toFixed(1)}' cy='#{y.toFixed(1)}' r='#{size}' class='star' style='animation-delay: #{delay}s'/>"

  # 8 anchor stars in a ring + faint constellation lines between adjacent ones
  anchors = ""
  lines = ""
  prev = null
  for i in [0...8]
    a = (i * 45) * Math.PI / 180
    r = 200
    x = cx + r * Math.cos(a)
    y = cy + r * Math.sin(a)
    anchors += "<circle cx='#{x.toFixed(1)}' cy='#{y.toFixed(1)}' r='2.5' class='anchor'/>"
    if prev?
      lines += "<line x1='#{prev[0].toFixed(1)}' y1='#{prev[1].toFixed(1)}' x2='#{x.toFixed(1)}' y2='#{y.toFixed(1)}' class='ln'/>"
    prev = [x, y]

  """
    <svg viewBox="0 0 600 600" class="sky">
      <g class="spin">
        #{lines}
        #{stars}
        #{anchors}
      </g>
    </svg>
  """

style: """
  position: absolute
  top: 50%
  right: 50px
  transform: translateY(-50%)
  width: 380px
  height: 380px
  opacity: 0.75
  pointer-events: none

  .sky
    width: 100%
    height: 100%

  .spin
    transform-origin: 300px 300px
    animation: spin 1800s linear infinite

  .star
    fill: #d8dee9
    animation: twinkle 4s ease-in-out infinite

  .anchor
    fill: #88c0d0
    filter: drop-shadow(0 0 4px #88c0d0)

  .ln
    stroke: #4c566a
    stroke-width: 0.6
    opacity: 0.35

  @keyframes spin
    from
      transform: rotate(0deg)
    to
      transform: rotate(360deg)

  @keyframes twinkle
    0%, 100%
      opacity: 0.3
    50%
      opacity: 1
"""
