app = require '../Application'
require './ConfigService'

################################################
## LocationService
## get(): Retrieves all Location items
################################################
LocationService = ($resource, ConfigService) ->

  cls = {}

  cls.resource = $resource(ConfigService.apiUrl + "/location", {}, get: {isArray: true})

  cls.get = () ->
    return cls.resource.get()

  return cls
 


module.exports = LocationService
app.factory 'LocationService', ['$resource', 'ConfigService', LocationService]
 