(function () {
  'use strict';

  angular
    .module('thatsaboy.index')
    .controller('requestRecoveryController', requestRecoveryController);

  requestRecoveryController.$inject = ['loginService', '$scope'];

  function requestRecoveryController(loginService, $scope) {
    var vm = this;
    vm.step = 1;

    vm.send = function () {
      $scope.recoveryForm.$setSubmitted();
      if ($scope.recoveryForm.$valid) {
        loginService.requestRecovery(vm.email).then(function (token) {
          vm.step = 2;
        });
      }
    };

    return vm;
  }

})();
