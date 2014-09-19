# CoffeeScript
app = require '../Application'
require '../filters/TrustHTMLFilter'
require '../filters/IfFilter'
require '../services/ConfigService'
require '../services/UserService'
require '../services/CompetencyMatrixService'

CompetencyController = ($scope, $rootScope, ConfigService, UserService, CompetencyMatrixService) ->

  $scope.users = UserService.get()
  $scope.apiUrl = ConfigService.apiUrl
  $scope.search = {}

    
  ################################################
  ## Fetch competency matrix correctly
  ## And populates the template
  ##
  ################################################       
  $scope.competenceMatrix  = CompetencyMatrixService.data
  

  $scope.doFiltering = () ->
    (item) ->
      exists = []
      
      if !$scope.search.name && !$scope.search.expertise && !$scope.search.level
        return item
      
     
      # Search for name
      if !!$scope.search.name
        if (item.firstname + " " + item.lastname).indexOf($scope.search.name) > -1
          exists.push(true)
         
      

      $.each item.expertise, (key,val) ->
        # Search for expertise name
        if !!$scope.search.expertise
          if val.name.indexOf($scope.search.expertise) > -1
            exists.push(true)
              
        # Search for expertise name
        if !!$scope.search.level
          if val.level == parseInt($scope.search.level)
            exists.push(true)
      
      
      console.log exists.indexOf(true) > -1
      console.log exists
      if exists.indexOf(true) > -1
        return item
    
      

  

module.exports = CompetencyController
app.controller 'CompetencyController',
  [
    '$scope',
    '$rootScope',
    'ConfigService',
    'UserService',
    'CompetencyMatrixService',
    CompetencyController
  ]
