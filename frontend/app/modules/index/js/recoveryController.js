(function () {
  'use strict';

  angular
    .module('thatsaboy.index')
    .controller('recoveryController', recoveryController);

  recoveryController.$inject = ['loginService', '$scope', '$stateParams'];

  function recoveryController(loginService, $scope, $stateParams) {
    var vm = this;
    vm.step = 1;
    
    vm.change = function () {
      $scope.recoveryForm.$setSubmitted();
      if ($scope.recoveryForm.$valid) {
        loginService.recovery(vm.password, $stateParams.token).then(function () {
          vm.step = 2;
        });
      }
    };

    return vm;
  }

})();
