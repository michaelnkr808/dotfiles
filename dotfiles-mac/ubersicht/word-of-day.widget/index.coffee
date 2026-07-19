# Word of the day — deterministic by day-of-year over a curated list of
# evocative words + definitions. No network, never fails.
# To rotate the list, edit WORDS below.

WORDS = [
  ['sonder',         'the realization that each passerby has a life as vivid and complex as your own']
  ['petrichor',      'the pleasant smell of earth after rain']
  ['serendipity',    'a fortunate happening by chance']
  ['mellifluous',    'sweet or musical, pleasant to hear']
  ['ephemeral',      'lasting for a very short time']
  ['saudade',        'a deep emotional state of nostalgic longing']
  ['ineffable',      'too great or extreme to be expressed in words']
  ['eunoia',         'beautiful thinking; a well mind']
  ['nepenthe',       'something that brings forgetfulness of grief']
  ['luminescent',    'emitting light not caused by heat']
  ['ataraxia',       'a state of serene calmness']
  ['apricity',       'the warmth of the sun in winter']
  ['wabi-sabi',      'finding beauty in imperfection']
  ['hiraeth',        'a homesickness for a home you cannot return to']
  ['komorebi',       'sunlight filtering through the leaves of trees']
  ['eudaimonia',     'a state of human flourishing']
  ['solivagant',     'one who wanders alone']
  ['yugen',          'profound awareness of the universe that triggers emotion beyond words']
  ['fernweh',        'an ache for distant places']
  ['iridescent',     'showing luminous colors that seem to change with the angle']
  ['quintessence',   'the most perfect example of a quality']
  ['vellichor',      'the strange wistfulness of used bookshops']
  ['ethereal',       'extremely delicate, seemingly too perfect for this world']
  ['mudita',         'sympathetic joy in the success of others']
  ['liminal',        'occupying a position at or on both sides of a boundary']
  ['susurrus',       'a soft murmuring or rustling sound']
  ['quiescent',      'in a state of inactivity; quiet']
  ['halcyon',        'denoting a past period of idyllic happiness and peace']
  ['sempiternal',    'eternal and unchanging; everlasting']
  ['zephyr',         'a soft gentle breeze']
  ['sonorous',       'imposingly deep and full in sound']
  ['resplendent',    'attractive and impressive through being richly colorful']
  ['cogent',         'clear, logical, and convincing']
  ['limerence',      'the state of being infatuated with another person']
  ['defenestration', 'the act of throwing someone out of a window']
  ['lucid',          'expressed clearly; easy to understand']
  ['esoteric',       'understood by only a small specialized group']
  ['mamihlapinatapai','a wordless look shared by two hoping the other will do what neither wants to']
  ['tessellate',     'to cover with a pattern of repeated shapes']
  ['susurrate',      'to whisper or rustle softly']
]

command: "/bin/date '+%j'"

refreshFrequency: 3600000   # check hourly, but only changes once per day

render: (output) ->
  dayOfYear = parseInt(output.trim(), 10)
  [word, def] = WORDS[dayOfYear % WORDS.length]
  """
    <div class="label">word of the day</div>
    <div class="word">#{word}</div>
    <div class="def">#{def}</div>
  """

style: """
  position: absolute
  top: 270px
  left: 50%
  transform: translateX(-50%)
  width: 520px
  font-family: 'Iowan Old Style', 'Georgia', serif
  text-align: center
  user-select: none

  .label
    font-family: 'JetBrainsMono Nerd Font', monospace
    font-size: 13px
    font-weight: 700
    color: #d8dee9
    letter-spacing: 5px
    text-transform: uppercase
    margin-bottom: 12px
    text-shadow: 0 0 10px rgba(216, 222, 233, 0.25)

  .word
    font-size: 48px
    font-weight: 400
    font-style: italic
    color: #88c0d0
    text-shadow: 0 0 28px rgba(136, 192, 208, 0.35)
    line-height: 1.1
    margin-bottom: 14px

  .def
    font-size: 16px
    font-weight: 400
    color: #d8dee9
    line-height: 1.5
    opacity: 0.9
"""
