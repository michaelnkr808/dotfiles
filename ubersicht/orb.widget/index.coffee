# Breathing orb — single Frost-blue radial-gradient sphere pulsing in the corner.
# Pure CSS, no command.

command: ""

refreshFrequency: false

render: -> '<div class="orb"></div>'

style: """
  position: absolute
  bottom: 60px
  left: 60px
  pointer-events: none

  .orb
    width: 90px
    height: 90px
    border-radius: 50%
    background: radial-gradient(circle at 32% 32%, #88c0d0 0%, #5e81ac 70%, #2e3440 100%)
    box-shadow: 0 0 80px rgba(136, 192, 208, 0.45), 0 0 30px rgba(136, 192, 208, 0.7)
    animation: breathe 4.5s ease-in-out infinite

  @keyframes breathe
    0%, 100%
      transform: scale(0.82)
      opacity: 0.55
    50%
      transform: scale(1.08)
      opacity: 1
"""
