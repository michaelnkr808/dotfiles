# Nord gradient mesh — three soft Frost-blue blobs drift across the desktop.
# Pure CSS, no command. Sits behind everything (z-index: -1).

command: ""

refreshFrequency: false

render: -> """
  <div class="blob b1"></div>
  <div class="blob b2"></div>
  <div class="blob b3"></div>
"""

style: """
  position: absolute
  top: 0
  left: 0
  width: 100vw
  height: 100vh
  overflow: hidden
  z-index: -1
  pointer-events: none

  .blob
    position: absolute
    border-radius: 50%
    filter: blur(140px)
    opacity: 0.45
    will-change: transform

  .b1
    width: 700px
    height: 700px
    background: #5e81ac
    top: 5%
    left: 5%
    animation: drift1 35s ease-in-out infinite

  .b2
    width: 600px
    height: 600px
    background: #81a1c1
    top: 45%
    left: 55%
    animation: drift2 45s ease-in-out infinite

  .b3
    width: 800px
    height: 800px
    background: #88c0d0
    top: 65%
    left: 15%
    animation: drift3 55s ease-in-out infinite

  @keyframes drift1
    0%, 100%
      transform: translate(0, 0) scale(1)
    50%
      transform: translate(220px, 120px) scale(1.15)

  @keyframes drift2
    0%, 100%
      transform: translate(0, 0) scale(1)
    50%
      transform: translate(-180px, 140px) scale(0.9)

  @keyframes drift3
    0%, 100%
      transform: translate(0, 0) scale(1)
    50%
      transform: translate(140px, -120px) scale(1.1)
"""
