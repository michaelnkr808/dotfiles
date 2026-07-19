# GitHub contribution graph — pulls public SVG from ghchart.rshah.org
# and rewrites the raw hex colors to a Nord progression (Polar Night → Frost).

command: "/usr/bin/curl -s 'https://ghchart.rshah.org/88c0d0/michaelnkr808'"

refreshFrequency: 3600000   # 1 hour

render: (output) ->
  output
    .replace(/#EEEEEE/g, '#3b4252')
    .replace(/#d5ffff/g, '#5e81ac')
    .replace(/#bbf3ff/g, '#81a1c1')
    .replace(/#6d9aa6/g, '#8fbcbb')
    .replace(/#767676/g, '#d8dee9')

style: """
  position: absolute
  bottom: 60px
  left: 50%
  transform: translateX(-50%)
  width: 680px
  padding: 18px 24px
  background: rgba(46, 52, 64, 0.35)
  border-radius: 12px
  pointer-events: none

  svg
    width: 100%
    height: auto
    display: block
"""
