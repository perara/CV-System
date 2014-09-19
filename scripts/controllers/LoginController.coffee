app = require '../Application'
require '../services/AuthService'


LoginController = ($scope, AuthService, ConfigService) ->

  ################################################
  ## Login the user if form validation is good
  ################################################  
  $scope.login = () ->
  
    # Form validation
    if !$scope.userLogin.username
      return
    if !$scope.userLogin.password
      return
  
  
    AuthService.login($scope.userLogin, $scope, (success) ->
      if success
        window.location = "#";
    )
   
  ################################################
  ## Fetch all cookies, this is a workaround because
  ## Some cookies have trouble beeing set correctly.
  ## This "workaround" fixes the prawblem
  ################################################ 
  $.ajax(
          url: ConfigService.apiUrl + '/get-cookies'
          data: ""
          type: 'GET'
          crossDomain: true
          async: false
          dataType: 'json'
  ).always (xhr) ->

    return



module.exports = LoginController
app.controller 'LoginController',
  ['$scope',
   'AuthService',
   'ConfigService',
   LoginController]