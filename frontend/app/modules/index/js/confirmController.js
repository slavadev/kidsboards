(function () {
  'use strict';

  angular
    .module('thatsaboy.index')
    .controller('confirmController', confirmController);

  confirmController.$inject = ['loginService', '$stateParams'];

  function confirmController(loginService, $stateParams) {
    var vm = this;
    loginService.confirm($stateParams.token);
    return vm;
  }

})();
