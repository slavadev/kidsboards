(function () {
  'use strict';
  angular
    .module('thatsaboy')
    .config([
      '$httpProvider',
      '$locationProvider',
      'localStorageServiceProvider',
      '$mdIconProvider',
      '$mdThemingProvider'
      ,
      function ($httpProvider,
                $locationProvider,
                localStorageServiceProvider,
                $mdIconProvider,
                $mdThemingProvider) {

        /*disabling json serialising in $http requests,
         setting default key=value encoding
         and content-type
         TIP:
         to send GET request with array as a parameter
         use "key[]" instead of "key" in params object*/
        $httpProvider.defaults.transformRequest = function (data) {
          if (data === undefined) {
            return data;
          }
          var result = {};
          for (var key in data) {
            if (key.substring(0, 1) == '$') {
              continue;
            }
            result[key] = data[key];
          }
          return $.param(result);
        };

        //$locationProvider.html5Mode(true);
        //$locationProvider.hashPrefix('!');

        localStorageServiceProvider.setPrefix('thatsaboy');

        $mdIconProvider
          .icon("index:toy", "images/index/toy.svg", 512)
          .icon("index:number", "images/index/number.svg", 512)
          .icon("index:up", "images/index/up.svg", 512)
          .icon("index:medal", "images/index/medal.svg", 512);

        $mdThemingProvider.theme('default')
          .primaryPalette('purple');
      }]
  )
})();