app = require '../Application'


# Usage:
# <div ng-repeat="n in [20, 29] | makeRange">Do something 20..29: {{n}}</div>
# <div ng-repeat="n in [10] | makeRange">Do something 0..9: {{n}}</div>
RangeFilter = ->
  (input) ->
    lowBound = undefined
    highBound = undefined
    switch input.length
      when 1
        lowBound = 0
        highBound = parseInt(input[0]) - 1
      when 2
        lowBound = parseInt(input[0])
        highBound = parseInt(input[1])
      else
        return input
    result = []
    i = lowBound

    while i <= highBound
      result.push i
      i++
    result

module.exports = RangeFilter
app.filter "makeRange", RangeFilter