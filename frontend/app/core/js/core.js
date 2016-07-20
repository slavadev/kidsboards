(function () {
  'use strict';

  angular
    .module('thatsaboy.core',
    [
      'ui.router',
      'LocalStorageModule',
      'thatsaboy.common',
      'ngAnimate'
    ]
  );
  
  angular
    .module('thatsaboy.core')
    .controller('AppController', AppController);

  AppController.$inject = [];

  function AppController() {
    var vm = this;
    return vm;
  }

})();