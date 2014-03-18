{WorkspaceView, $} = require 'atom'

BackgroundMatrixView = require '../lib/background-matrix-view'

# Use the command `window:run-package-specs` (cmd-alt-ctrl-p) to run specs.
#
# To run a specific `it` or `describe` block add an `f` to the front (e.g. `fit`
# or `fdescribe`). Remove the `f` to unfocus the block.

describe "BackgroundMatrix", ->
  [backgroundMatrix, backgroundMatrixView] = []

  activatePackage = (callback) ->
    waitsForPromise ->
      atom.packages.activatePackage('background-matrix').then ({mainModule}) ->
        {backgroundMatrixView} = mainModule

    runs ->
      callback()

  describe "when the package is activated when there is only one pane", ->
    beforeEach ->
      atom.workspaceView = new WorkspaceView
      expect(atom.workspaceView.getPanes().length).toBe 1

    describe "when the pane is empty", ->
      it "attaches the view after a delay", ->
        expect(atom.workspaceView.getActivePane().getItems().length).toBe 0

        activatePackage ->
          expect(backgroundMatrixView.parent()).not.toExist()
          advanceClock BackgroundMatrixView.startDelay + 1
          expect(backgroundMatrixView.parent()).toExist()

    describe "when the pane is not empty", ->
      it "does not attach the view", ->
        atom.workspaceView.getActivePane().activateItem($("item"))

        activatePackage ->
          advanceClock BackgroundMatrixView.startDelay + 1
          expect(backgroundMatrixView.parent()).not.toExist()

    describe "when a second pane is created", ->
      it "detaches the view", ->
        activatePackage ->
          advanceClock BackgroundMatrixView.startDelay + 1
          expect(backgroundMatrixView.parent()).toExist()

          atom.workspaceView.getActivePane().splitRight()
          expect(backgroundMatrixView.parent()).not.toExist()

  describe "when the package is activated when there are multiple panes", ->
    beforeEach ->
      atom.workspaceView = new WorkspaceView
      atom.workspaceView.getActivePane().splitRight()
      expect(atom.workspaceView.getPanes().length).toBe 2

    it "does not attach the view", ->
      activatePackage ->
        advanceClock BackgroundMatrixView.startDelay + 1
        expect(backgroundMatrixView.parent()).not.toExist()

    describe "when all but the last pane is destroyed", ->
      it "attaches the view", ->
        activatePackage ->
          atom.workspaceView.getActivePane().remove()
          advanceClock BackgroundMatrixView.startDelay + 1
          expect(backgroundMatrixView.parent()).toExist()

  describe "when the view is attached", ->
    beforeEach ->
      atom.workspaceView = new WorkspaceView
      expect(atom.workspaceView.getPanes().length).toBe 1

      activatePackage ->
        advanceClock BackgroundMatrixView.startDelay + 1

    it "has a canvas in the container", ->
      expect(backgroundMatrixView.container.children('canvas')).toBeTruthy()
