(function () {
  'use strict';

  angular
    .module('kidsboards.core',
    [
      'ui.router',
      'LocalStorageModule',
      'kidsboards.common',
      'ngAnimate'
    ]
  );

  angular
    .module('kidsboards.core')
    .controller('AppController', AppController);

  AppController.$inject = ['apiLinkService', '$timeout', '$http'];

  function AppController(apiLinkService, $timeout, $http) {
    var vm = this;
    // Defaults
    vm.loading = false;
    vm.wokeup = false;
    // Show "loading" after 3 seconds
    $timeout(function () {
      if (vm.wokeup) {
        return
      }
      vm.loading = true;
    }, 3000);
    // Try to wake up the app
    $http({
      method: 'GET',
      url: apiLinkService.createUrl('wakeup')
    }).then(function() {
      vm.loading = false;
      vm.wokeup = true;
    })
    return vm;
  }

})();
