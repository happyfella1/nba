class PlayerInfo
    name: ''
    position: ''
    college: ''
    draftYear: ''
    debutYear: ''

    constructor: (@name, @position, @college, @draftYear, @debutYear) ->
        if (@position.indexOf('Center-Forward') == 0)
            @position = 'Center-Forward'
        else if (@position.indexOf('Guard-Forward') == 0)
            @position = 'Guard-Forward'
        else if (@position.indexOf('Forward-Guard') == 0)
            @position = 'Forward-Guard'
        else if (@position.indexOf('Forward-Center') == 0)
            @position = 'Forward-Center'
        else if (@position.indexOf('Center') == 0)
            @position = 'Center'
        else if (@position.indexOf('Guard') == 0)
            @position = 'Guard'
        else if (@position.indexOf('Forward') == 0)
            @position = 'Forward'

        if (@draftYear.length > 4)
            @draftYear = draftYear.substring(0, 4)

        if (@debutYear.indexOf(',') >= 0 && @debutYear.indexOf(',') + 1 < @debutYear.length)
            @debutYear = debutYear.substring(@debutYear.indexOf(',') + 1).trim()

    toString: => 
        "#{@name}, #{@position}, #{@college}, #{@draftYear}, #{@debutYear}"

    toJSON: =>
        '{"name": "' + @name + '", "position": "' + @position + '", "college": "' + @college + '", "draftYear": "' + @draftYear + '", "debutYear": "' + @debutYear + '"}'

module.exports = PlayerInfo