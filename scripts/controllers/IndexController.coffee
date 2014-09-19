app = require '../Application'
require '../services/UserService'

IndexController = ($scope, $rootScope, UserService) ->

  ################################################
  ## Fetch the logged in user via UserService, and 
  ## bind $scope.user
  ################################################  
  UserService.getLoggedInUser (user) ->
    $scope.user = user 



module.exports = IndexController
app.controller 'IndexController',
  [
    '$scope',
    '$rootScope',
    'UserService'
    IndexController
  ]
