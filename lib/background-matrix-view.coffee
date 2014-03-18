{View} = require 'atom'
config = atom?.config
Matrix = require './matrix'

module.exports =
class BackgroundMatrixView extends View
  @startDelay: 1000
  @CONFIG:
      color : "#FFF",
      fontSize : 10,
      speed : 3,
      chance : 0.975,
      tailLength : 40

  @content: ->
    @ul class: 'background-matrix centered background-message', =>
      @li outlet: 'container'

  initialize: ->
    @index = -1

    rtable = [];
    for j in [0..10000]
      rtable.push(Math.random());

    Matrix.options.speedForColumn = (c, t) ->
      (3 * Math.pow(Math.sin(4 * Math.PI * c / Math.floor(t) ), 2) + 2 * rtable[c]);

    atom.workspaceView.on 'pane-container:active-pane-item-changed pane:attached pane:removed', => @updateVisibility()
    setTimeout @start, @constructor.startDelay

  attach: ->
    pane = atom.workspaceView.getActivePane()
    top = pane.children('.item-views').position()?.top ? 0
    @css('top', top)
    pane.append(this)

  updateVisibility: ->
    if @shouldBeAttached()
      @start()
    else
      @stop()

  shouldBeAttached: ->
    atom.workspaceView.getPanes().length is 1 and not atom.workspaceView.getActivePaneItem()?

  start: =>
    return if not @shouldBeAttached()
    @attach()
    @showMatrix()

  stop: =>
    Matrix.land @matrix
    @detach()

  showMatrix: =>
    @configureMatrix()
    @matrix = Matrix.fly(@container)
    @matrix.forcestop = true

  configureMatrix: =>
    return unless config?
    Matrix.options.color = config.get('background-matrix.color')
    Matrix.options.fontSize = config.get('background-matrix.fontSize')
    Matrix.options.speed = config.get('background-matrix.speed')
    Matrix.options.chance = config.get('background-matrix.chance')
    Matrix.options.tailLength = config.get('background-matrix.tailLength')
    characters = ""
    if config.get('background-matrix.chineseCharacters')
      characters += Matrix.letters.chinese;
    if config.get('background-matrix.lowercaseEnglishCharacters')
      characters += Matrix.letters.lowercaseEnglish
    if config.get('background-matrix.uppercaseEnglishCharacters')
      characters += Matrix.letters.uppercaseEnglish
    if config.get('background-matrix.digitCharacters')
      characters += Matrix.letters.digits
    if config.get('background-matrix.leetCharacters')
      characters += Matrix.letters.leet
    characters += config.get('background-matrix.customCharacters')
    if (characters is "")
      characters = Matrix.letters.lowercaseEnglish + Matrix.letters.uppercaseEnglish + Matrix.letters.digits
    Matrix.options.letters = characters
