app = require '../Application'
require '../filters/TrustHTMLFilter'
require '../services/ConfigService'
require '../services/UserService'

CvListController = ($scope, $rootScope, ConfigService, UserService) ->

  $scope.users = UserService.get()
  $scope.apiUrl = ConfigService.apiUrl

  ################################################
  ## Downloads the PDF, does it via a iframe (OMG)
  ## Since AJAX cannot handle headers properly
  ## On download.
  ################################################   
  $scope.showPDF = (id) ->
    frame = $('<iframe id="dl" name="cvdl" style="display:none">')
    $(frame).attr('src', ConfigService.apiUrl + "/pdf/" + id); 
    $(frame).appendTo("body")
    $(frame).load ->
      $(frame).remove();
    return


module.exports = CvListController
app.controller 'CvListController',
  [
    '$scope',
    '$rootScope',
    'ConfigService',
    'UserService',
    CvListController
  ]
