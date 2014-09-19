app = require './Application'
require './controllers/CurriculumController'
require './controllers/LoginController'
require './controllers/TemplateController'
require './controllers/IndexController'
require './controllers/LogoutController'
require './controllers/CvListController'
require './controllers/CompetencyController'
require 'jquery-cookie'

################################################
## Application Root Configuration
## Contains primarily the routing table.
################################################
app.config ($routeProvider, $httpProvider) ->


  $httpProvider.defaults.withCredentials = true
  $httpProvider.defaults.useXDomain = true;

  $httpProvider.defaults.xsrfHeaderName = 'X-CSRFToken'

  $routeProvider
  .when '/',
    templateUrl: 'views/Index.html'
    controller: 'IndexController'
  .when '/cv',
    templateUrl: 'views/Curriculum.html'
    controller: 'CurriculumController'
  .when '/login',
    templateUrl: 'views/Login.html'
    controller: 'LoginController'
  .when '/logout',
    templateUrl: 'views/Logout.html'
    controller: 'LogoutController'
  .when '/template',
    templateUrl: 'views/Template.html'
    controller: 'TemplateController'
  .when '/cv-list',
    templateUrl: 'views/CvList.html'
    controller: 'CvListController'
  .when '/comp-list',
    templateUrl: 'views/Competency.html'
    controller: 'CompetencyController'

  .otherwise
  redirectTo: '/'




################################################
## Checks authentication before a route is changed
################################################
app.run ($http, $cookies, $location, ConfigService, $rootScope) ->
  
  # Ensure that the user is logged in, else, Navigate to the login page (Dont do this when @ login
  $rootScope.$on '$locationChangeStart', (event, next, current)  ->
    
    # Ignore if login
    if next.split("/").pop() is ""
      return
  
    request = $http(
      method: 'GET'
      url: ConfigService.apiUrl + "/check-auth"
    )
    request.error (data, status, headers, config) ->
      if status is 403
        $location.path("/");
        
        
    # Deactivates "navigate back" on backspace
    $(document).on "keydown", (e) ->
      e.preventDefault()  if e.which is 8 and not $(e.target).is("input, textarea, div")
      return
        
     
    






