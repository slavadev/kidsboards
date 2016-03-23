(function () {
  'use strict';

  angular
    .module('thatsaboy.core',
    [
      'ui.router',
      'LocalStorageModule',
      'thatsaboy.common'
    ]
  ).controller('AppController', AppController);


  function AppController() {
    var vm = this;

    return vm;
  };

})();