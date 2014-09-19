app = require '../Application'
require '../services/AuthService'


LogoutController = ($scope, $location, $sce, AuthService, ConfigService) ->

  ################################################
  ## Push logout through a iframe, AJAX have troubles
  ## Unsetting session,
  ################################################
  $scope.apiUrl = $sce.trustAsResourceUrl(ConfigService.apiUrl + "/logout&output=embed");
  $('iframe').load ->
    window.location = "#/login";



module.exports = LogoutController
app.controller 'LogoutController',
  ['$scope',
   '$location',
   '$sce',
   'AuthService',
   'ConfigService',
   LogoutController]