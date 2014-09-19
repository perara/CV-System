app = require '../Application'
require './ConfigService'

################################################
## DepartmentService: 
## get() Fetches all departments
################################################
DepartmentService = ($resource, ConfigService) ->

  cls = {}

  cls.resource = $resource(ConfigService.apiUrl + "/department", {}, get: {isArray: true})

  cls.get = () ->
    return cls.resource.get()

  return cls
 


module.exports = DepartmentService
app.factory 'DepartmentService', ['$resource', 'ConfigService', DepartmentService]
 