app = require '../Application'

# Usage:  {{ a != b | iif scopevar}}
Filter =  ->
  return (input, trueValue, falseValue) ->
    return input ? trueValue : falseValue


module.exports = Filter
app.filter 'iif', Filter