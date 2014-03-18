BackgroundMatrixView = require './background-matrix-view'

module.exports =

    configDefaults:
        color : "#FFF",
        fontSize : 10,
        speed : 3,
        chance : 0.975,
        tailLength : 40,
        chineseCharacters : false,
        lowercaseEnglishCharacters: true,
        uppercaseEnglishCharacters: true,
        digitCharacters: true,
        leetCharacters: false,
        customCharacters: ""

    activate: ->
        @backgroundMatrixView = new BackgroundMatrixView()

    deactivate: ->
        @backgroundMatrixView.remove()
