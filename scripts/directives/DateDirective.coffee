app = require '../Application'

DateTimez =  ->
  restrict: "A"
  require: "ngModel"
  link: (scope, element, attrs, ngModelCtrl) ->
    element.datetimepicker(
      format: "MM-yyyy"
      viewMode: "months"
      minViewMode: "months"
      pickTime: false
    ).on "changeDate", (e) ->
      ngModelCtrl.$setViewValue e.date
      scope.$apply()
      return

    return


module.exports = DateTimez
app.directive "datetimez", DateTimez