app = require "../Application"
PDFService = require '../services/PDFService'
CVStorageService = require '../services/CVService'
CompetencyMatrixService = require '../services/CompetencyMatrixService'
DepartmentService = require '../services/DepartmentService'
LocationService = require '../services/LocationService'
LanguageService = require '../services/LanguageService'
LanguageLevelService = require '../services/LanguageLevelService'

# Filters
require '../filters/ForRangeFilter'
require '../filters/TrustHTMLFilter'


# Directives
require '../directives/DateDirective'

 
CurriculumController = (
  $scope, 
  $rootScope, 
  $http, 
  $compile, 
  PDFService, 
  ConfigService,
  CVService, 
  $modal, 
  CompetencyMatrixService, 
  Department, 
  Location, 
  Language, 
  LanguageLevelService,
  $route
) ->
  $scope.percentage = 0;


  $scope.cv = CVService.getCV()
  $scope.$watch "cv", ((newVal, oldVal) ->
    if !oldVal.$resolved
      return
    $scope.saved = false
    return
  ), true
  $scope.saved = true
  $scope.deleted = {} # Sent to server for deletion
  $scope.departments = Department.get()
  $scope.locations = Location.get()
  $scope.languages = Language.get() 
  $scope.languageLevels = LanguageLevelService.get() # Fetches Levels for language ie: 1 = Lav Ferdighet...
  $scope.competenceMatrix  = CompetencyMatrixService.data
        
  ################################################
  ## Event function which adds a new language when user has selected one
  ## $item - The Selected item (Basicly Model)
  ## $model - The Model Item
  ## $label - Text of the typeahead field (The label for the model)
  ################################################
  $scope.addLanguage = ($item, $model, $label) ->
    writtenLevel = $scope.writtenLevel
    verbalLevel = $scope.verbalLevel
    $scope.selectedLanguage = null
    $scope.languageLevel = null
    $scope.validation = []
  
    # Ensure that level is set
    if !writtenLevel || !verbalLevel
      alert("You must select a level!")
      return false

    $scope.cv.user.language.push({
      'language': $item.id,
      'verbal': verbalLevel,
      'written': writtenLevel
    })


  ################################################
  ## Event function which is fired onChange when a picture has been selected.
  ## Uploads the image to the server via a Post
  ## files - The files[] array which is built in html/js
  ################################################
  $scope.uploadImage = (files) ->
  
    # Create a new formData item (Form)
    fd = new FormData();
    fd.append("file", files[0]);

    $http.post(ConfigService.apiUrl + "/image-upload", fd, {
        withCredentials: true,
        headers: {'Content-Type': undefined },
        transformRequest: angular.identity
    })
    .success( (data) ->
      full_url = ConfigService.apiUrl + data.result
      $scope.cv.picture = full_url
  
    )
    .error( (data) ->
      alert("Det skjedde en feil, Kontakt Admin")
    )
    
  ################################################
  ## Event function for when a competency item i selected (Competency Matrix)
  ## $item - The Selected item (Basicly Model)
  ## $model - The Model Item
  ## $label - Text of the typeahead field (The label for the model)
  ################################################
  $scope.onMatriceSelect = ($item, $model, $label) ->
    
    # Reset the competency input field
    $scope.selectedCompetency = null

    # Create a modal for selecting skill level
    modalInstance = $modal.open(
      templateUrl: "skillModal.html"
      controller: ModalInstanceController
      size: ''
      resolve:
        items: ->
          $item
    )

    # Callback with the result data
    modalInstance.result.then ((result) ->

      # Check for duplicate.
      exists = false
      $.each($scope.cv.user.expertise, (key,val) ->
        if (val.id == result.id)
          exists = true
      )

      if !exists
        $scope.cv.user.expertise.push({
          'id': result.id,
          'level': result.level
        })
    )

  """
  Datepicker Configuration 
  """
  $scope.today = new Date();
  $scope.currentYear = $scope.today.getFullYear()
  $scope.format = "yyyy-MM"
  $scope.dateOptions = {
  'year-format': "'yy'",
  'starting-day': 1,
  'datepicker-mode':"'month'",
  'min-mode':"month"   };
  ################################################
  ## Event function for when a input field with datepicker is clicked on
  ## Action: opens the calendar
  ## $event - Event that is fired.
  ## opened - Bool which describes if the datepicker is open
  ################################################
  $scope.open = ($event, opened) ->
    $event.preventDefault()
    $event.stopPropagation()
    
    if !$scope.calendar
      $scope.calendar = []
    
    if $.inArray(opened, $scope.calendar) is -1
      $scope.calendar.push(opened)
    
    # Hide all calendars
    $.each($scope.calendar, (key,val) ->
      $scope[val] = false
      console.log ""
    )
    
    # Activated the clicked calendar.
    $scope[opened] = true



  ################################################
  ## Tab Initialization: Activates the bootstrap tabbing system
  ## for both Main tab and the info tab in Page (2)
  ################################################
  # Main tab 
  $("#myTab a").on 'click', (e) ->
    $(this).tab('show')
    e.preventDefault()
    return false
    
  #Tab 2 Inner info tab    
  $("#infotab a").on 'click', (e) ->
    $(this).tab('show')
    e.preventDefault()
    return false

  $scope.nextTab = ->
    $('#myTab > .active').next('li').find('a').trigger('click');
    return
    
    
  """
  # TextAngular Configuration
  """
  $scope.textAngularOptions = 
  [
    ['bold', 'italics', 'underline', 'ul', 'ol', 'redo', 'undo', 'clear'], 
    ['justifyLeft','justifyCenter','justifyRight']
  ]
  
  ################################################
  ## This function validates the $scope.cv, 
  ## Used in: savePDF and saveCV functions before execution
  ## It then compiles all errors into a list of erros.
  ################################################
  $scope.validateForm = () ->
    cv = $scope.cv
    messages = []
    if cv.picture == ""
      messages.push("Picture is missing!")
    return messages
    
    
  ################################################
  ## Saves the PDF to the database, It uses summary 
  ## Tab to generate the PDF (tab4)
  ################################################
  $scope.savePDF = () ->
  
    # Get the Template data
    cvTemplate = $(".template-body").html()
    
    # Validate the form
    valid = $scope.validateForm()
    console.log valid.length
    if valid.length != 0 #Not valid if true
      alert(valid) 
      return false
    
    data =  {
      'body': cvTemplate,
      'name' : $scope.cv.user.firstname + " " + $scope.cv.user.lastname
    }
    
    PDFService.post(data)
    return true

  ################################################
  ## Saves the cv to the database via CVService
  ## It saves via AJAX, also does validation before
  ## submission.
  ## Also updates removed CV fields
  ################################################
  $scope.saveCV = () ->
    
    # Validate the form 
    valid = $scope.validateForm()
    if valid.length != 0
      alert(valid)
      return false
    
    # Save
    CVService.save($scope.cv)
    
    # Update (Removal)
    CVService.remove($scope.deleted, ->
      $scope.deleted = {}
      #location.reload()

    )
    $scope.saved = true
    $route.reload();

    return true
    
    
  ############################################################
  ## TAB 3 - Erfaringer - Experience and Mission
  ## Contains all of the event function used for creating experiences
  ## Also contains the logic behind ordering.
  ############################################################
  $scope.experience = {}
  $scope.createExperience = () ->
    
    
    # Validation
    isValid = true
    if !$scope.experience.from
      $scope.validation.push("From Date is not set!")
    if !$scope.experience.until
      $scope.validation.push("Until Date is not set!")
    if $scope.experience.from > $scope.experience.until
      $scope.validation.push("From is set Before todo")
    
    
  
    
    # If In_sysco is set, force name as sysco
    if $scope.experience.insysco
      $scope.experience.company = "Sysco"
    
    if !$scope.experience.insysco
      $scope.experience.insysco = "false"
  
    # Insert into the $scope.cv with currently set values in $scope.experience
    $scope.cv.experience.push({
      'from_date': $scope.experience.from,
      'until_date': $scope.experience.until,
      'company': $scope.experience.company,
      'in_sysco': $scope.experience.insysco,
      'mission': []
      'order': $scope.cv.experience.length
    })
    
    # Reset 
    $scope.experience = {}
    return true
    
  $createMission = (experienceItem) ->
 
    experienceItem.mission.push({
      'title' : '',
      'text' : '',
      'order': experienceItem.mission.length
    })
    return true
    
    
    
  ################################################
  ## Section: Array Smoothness & Generalization sugar
  ##  - Contains functions for array manipulations
  ##  - Generalized functions 
  ################################################ 
  $scope.orderUp = (index, array) ->
    if !array[index-1]
      return false
      
    tmp = array[index]
    
    # Also set a Order var
    array[index].order = index-1
    array[index-1].order = index
      
    array[index] = array[index-1]
    array[index-1] = tmp
    return true
    
  $scope.orderDown = (index, array) ->
    if !array[index+1]
      return false
      
    # Also set a Order var
    array[index].order = index+1
    array[index+1].order = index
  
    tmp = array[index]
    array[index] = array[index+1]
    array[index+1] = tmp
    

    
    return true
    
  $scope.remove = (item, array, callername) ->
  
    # Add to remove dict if callername is set
    if !!callername
      if !$scope.deleted[callername]
        $scope.deleted[callername] = []
        
      
      # Push the ID of the item to delete (The User will be verified serverside)
      $scope.deleted[callername].push(item.id)
      
  
      array.splice(array.indexOf(item),1);
      
  $scope.new = (array) ->
    array.push({'order': array.length})
    
  # This function gets a item by searching after the ID field within a object array (id property is required)
  $scope.get = (id, array) ->
    item = null
    $.each array, (key, val) ->
      if val.id == id
        item = val
        return
    return item
    
  $scope.keyget = (id, array) ->
    return array[id]
    
  $scope.startsWith = (actual, expected) ->
    lowerStr = (actual + "").toLowerCase()
    return lowerStr.indexOf(expected.toLowerCase()) == 0

  ################################################
  ## Section END: Array Smoothness
  ################################################    
  
  ################################################
  ##
  ## Validation
  ##
  ################################################
  $scope.$watch 'validation', ->
    return


################################################
## Partial Controller:
## - This controller is used on the Modal when
##   selecting competency from the typeahead
################################################      
ModalInstanceController = ($scope, $modalInstance, items) ->

  # Max Skill level (100%)
  $scope.max = 100

  # Current Skill level
  $scope.skill = 0

  # The item selected from input
  $scope.item = items

  $scope.ok = ->

    # Convert 100 Level to 4 levels
    $scope.item.level = ($scope.item.level / $scope.max) *4


    $modalInstance.close $scope.item

  $scope.cancel = ->
    $scope.level = undefined
    $modalInstance.dismiss "cancel"



module.exports = CurriculumController
app.controller 'CurriculumController',
  ['$scope',
   '$rootScope',
   '$http',
   '$compile',
   'PDFService',
   'ConfigService',
   'CVService',
   '$modal',
   'CompetencyMatrixService',
   'DepartmentService',
   'LocationService',
   'LanguageService',
   'LanguageLevelService',
   '$route',
   CurriculumController]