app = require '../Application'

################################################
## Configuration Service, contains final data
## For example api information 
################################################
ConfigService = ->
  apiUrl: "http://172.20.16.219:8000"
  apiUrlLocal: "http://localhost:8000"
  DEBUG: true
  user: undefined
  
  # Implement Observer pattern, since Controllers is loaded BEFORE the Config is set in application.Config  
  watch: (callback) ->
    if not ConfigService.observer
      ConfigService.observer = []
      
    ConfigService.observer.push(callback)
    
  fireEvent: () ->
    if not ConfigService.observer
      ConfigService.observer = []
  
    $.each ConfigService.observer, (key,callback) ->
      callback(ConfigService.user)
      
  setUser: (user) ->
    ConfigService.user = user
    ConfigService().fireEvent()
      
 
    



module.exports = ConfigService
app.factory 'ConfigService', ConfigService