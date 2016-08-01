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

        //Enable cross domain calls
        $httpProvider.defaults.useXDomain = true;

        //Remove the header used to identify ajax call  that would prevent CORS from working
        // delete $httpProvider.defaults.headers.common['X-Requested-With'];


      }]
  )
})();