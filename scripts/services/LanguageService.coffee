# CoffeeScript
app = require '../Application'
require './ConfigService'

################################################
## LanguageService
## get(): Retrieves all Languages
################################################
LanguageService = ($resource, ConfigService) ->

  cls = {}

  cls.resource = $resource(ConfigService.apiUrl + "/language", {}, get: {isArray: true})

  cls.get = () ->
    return cls.resource.get()

  return cls
 


module.exports = LanguageService
app.factory 'LanguageService', ['$resource', 'ConfigService', LanguageService]
 