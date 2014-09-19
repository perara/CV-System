# CoffeeScript
app = require '../Application'

################################################
## LanguageLevelService
## get(): Returns a static list with language levels
################################################
LanguageLevelService = () ->

  get: () ->
    return {
    1: 'Lav Ferdighet',
    2: 'Middels Ferdighet',
    3: 'God Ferdighet',
    4: 'Morsmål'
    }


module.exports = LanguageLevelService
app.factory 'LanguageLevelService', LanguageLevelService