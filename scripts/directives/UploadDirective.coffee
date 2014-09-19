
UploadDirective = (uploadService) ->
  restrict: 'AE'
  link: (scope, elem, attrs) ->
    $(element).fileupload(
      dataType: 'text'
      add: (e, data) ->
        uploadService.add(data)

      progressall: (e, data) ->
        progress = parseInt(data.loaded / data.total * 100, 10)
        uploadService.setProgress progress

      done: (e, data) ->
        uploadService.setProgress 0
    )
