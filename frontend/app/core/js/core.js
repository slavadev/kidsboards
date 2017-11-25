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

  AppController.$inject = [];

  function AppController() {
    var vm = this;
    return vm;
  }

})();