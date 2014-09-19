app = require '../Application'
require '../services/ConfigService'

AuthService = (ConfigService, $http) ->
  
  ################################################
  ## Logins the user via Ajax
  ## data: The user credentials
  ## $scope: Controller's scope
  ## callback: Callback which returns a bool value 
  ##           weither the login was¨successfull or not
  ################################################
  login: (data, $scope, callback) ->

    request = $.ajax(
      url: ConfigService.apiUrl + '/login'
      data: data
      type: 'POST'
      crossDomain: true
      async: false
      dataType: 'json'
      headers: {
        'X_USERNAME': data.username,
        'X_PASSWORD': data.password
      },
      xhrFields: {
        withCredentials: true
      }
    )
    # Login Successfull
    request.success (data,type, xhr) =>
      cookies = document.cookie.split('; ');
      $scope.status = xhr.status
      $scope.detail = data.detail
      callback(true)

      # Create cookies (Workaround)
      $.each(data.data, (key,val) ->
        $.cookie(key,val)
      )
  
    # Login Failed
    request.fail (xhr, status_type) =>
      console.log xhr.status
      $scope.status = xhr.status
      $scope.detail = xhr.responseJSON.detail
      callback(false)


module.exports = AuthService
app.factory 'AuthService', ['ConfigService', '$http', AuthService]