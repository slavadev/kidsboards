(function () {
  'use strict';
  angular
    .module('thatsaboy')
    .config([
      '$httpProvider',
      '$locationProvider',
      'localStorageServiceProvider',
      '$mdThemingProvider'
      ,
      function ($httpProvider,
                $locationProvider,
                localStorageServiceProvider,
                $mdThemingProvider) {

        localStorageServiceProvider.setPrefix('thatsaboy');

        $mdThemingProvider.theme('default')
          .primaryPalette('purple')
          .accentPalette('pink');

        $mdThemingProvider.theme('dark', 'default')
          .primaryPalette('purple')
          .accentPalette('pink')
          .dark();


      }]
  )
})();