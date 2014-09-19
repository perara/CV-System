app = require '../Application'
require './ConfigService'

################################################
## PDFService
## post(pdfhtml): Posts PDF html to the server
################################################
PDFService = (ConfigService) ->

  post: (pdfhtml) ->


    newForm = jQuery('<form>', {
      'action': ConfigService.apiUrl + '/pdf/ ',
      'method': 'POST',
      'target': '_blank'
    })
    
    newForm.append(jQuery('<input>', {
      'name': 'body',
      'value': pdfhtml.body
      'type': 'hidden'
    }))
    
    newForm.append(jQuery('<input>', {
      'name': 'name',
      'value': pdfhtml.name
      'type': 'hidden'
    }));

    newForm.submit();


module.exports = PDFService
app.factory 'PDFService', PDFService