(function () {
  'use strict';
  angular
    .module('kidsboards')
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

        localStorageServiceProvider.setPrefix('kidsboards');

        $mdThemingProvider.theme('default')
          .primaryPalette('purple')
          .accentPalette('pink');

        $mdThemingProvider.theme('dark', 'default')
          .primaryPalette('purple')
          .accentPalette('pink')
          .dark();

        //Enable cross domain calls
        $httpProvider.defaults.useXDomain = true;
        $locationProvider.html5Mode(true);
        $locationProvider.hashPrefix('!');
      }]
  )
})();