(function () {
  'use strict';

  angular
    .module('thatsaboy.core',
    [
      'ui.router',
      'LocalStorageModule'
    ]
  ).controller('AppController', AppController);


  function AppController() {
    var vm = this;

    return vm;
  };

})();