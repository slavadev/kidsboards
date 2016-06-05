(function () {
  'use strict';

  angular
    .module('thatsaboy.index')
    .controller('indexController', indexController);

  indexController.$inject = ['loginService', '$state', '$scope'];

  function indexController(loginService, $state, $scope) {
    if (loginService.getToken()) {
      $state.go('app.family');
    }

    var vm = this;

    vm.login = function () {
      $scope.loginForm.$setSubmitted();
      if ($scope.loginForm.$valid) {
        loginService.login(vm.email, vm.password).then(function (token) {
          $state.go('app.family');
        });
      }
    };

    vm.register = function () {
      $scope.loginForm.$setSubmitted();
      if ($scope.loginForm.$valid) {
        loginService.register(vm.email, vm.password).then(function (token) {
          $state.go('app.family_new');
        });
      }
    };

    return vm;
  }

})();
