app = require '../Application'

TemplateController = ($scope) ->

module.exports = TemplateController
app.controller 'TemplateController',
  [
    '$scope',
    TemplateController
  ]
