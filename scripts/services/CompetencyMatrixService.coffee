app = require '../Application'
require './ConfigService'

################################################
## This service fetches CompetencyMatrix from the api
## It uses $resource wrapper, simplifying crud operations
## Data is set in .data node     
################################################
CompetencyMatrixService = ($resource, ConfigService) ->
  cls = {}

  cls.resource = $resource(ConfigService.apiUrl + "/expertise-item", {}, get: {isArray: true})

  cls.data = cls.resource.get((data)->
    return data
  )

  return cls


module.exports = CompetencyMatrixService
app.factory 'CompetencyMatrixService',['$resource', 'ConfigService', CompetencyMatrixService]