'use strict'

require 'angular'
require 'angular-route'
require 'angular-cookies'
require 'angular-animate'
require 'angular-resource'
require 'angular-sanitize'
require 'angular-touch'
require 'angular-ui-tinymce'
require 'bootstrap'
require 'angular-ui-bootstrap'
require 'jquery-file-upload'
require 'textAngular'

module.exports = angular.module('frontendApp', [
    'ngAnimate',
    'ngCookies',
    'ngResource',
    'ngRoute',
    'ngSanitize',
    'ngTouch',
    'ui.tinymce',
    'ui.bootstrap',
    'textAngular'
  ])
