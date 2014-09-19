# CoffeeScript
app = require '../Application'
require './ConfigService'

################################################
## UserService
## getLoggedInUser(callback): get current user
## get(): Fetches all users
################################################
UserService = ($resource, ConfigService, $http) ->

  cls = {}

  cls.resource = $resource(ConfigService.apiUrl + "/users", {}, get: {isArray: true})
  
  cls.getLoggedInUser = (callback) ->
    request = $http(method: 'GET', url: ConfigService.apiUrl + "/check-auth")
    
    request.success (data, status, headers, config) ->
      callback(data)
    

  cls.get = () ->
    return cls.resource.get()

  return cls
 


module.exports = UserService
app.factory 'UserService', ['$resource', 'ConfigService', '$http', UserService]
 