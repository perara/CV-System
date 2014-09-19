app = require '../Application'
require './ConfigService'

################################################
## CVService:
## getCV() - Fetches CV with id X
## save(cv) - Saves the CV with "cv" data
## remove(data,callback)
##     data: Contains dict of data to be removed
##     callback: Output sent back to caller
################################################
CVService = ($resource, ConfigService, $http) ->

  cls = {}

  cls.resource = $resource(ConfigService.apiUrl + "/cv/:id/ ")

  cls.getCV = () ->
    return cls.resource.get({id:0})

  cls.save = (cv) ->
    newCV = new cls.resource(cv)
    newCV.$save()

  cls.remove = (data, callback) ->

    $http.post(ConfigService.apiUrl + '/delete-cv-data/ ', JSON.stringify(data), {
        withCredentials: true,
        headers: {'Content-Type': 'application/json' },
        transformRequest: angular.identity
    }).success(callback)
    .error( (data) ->
      alert("Det skjedde en feil, Kontakt Admin")
    )
  
   
  return cls



module.exports = CVService
app.factory 'CVService', ['$resource', 'ConfigService', '$http', CVService]
