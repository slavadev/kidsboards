(function () {
  'use strict';

  angular
    .module('kidsboards.index')
    .controller('indexController', indexController);

  indexController.$inject = ['loginService', '$state', '$scope'];

  function indexController(loginService, $state, $scope) {
    var vm = this;

    if (loginService.getToken()) {
      $state.go('app.family');
    } else {
      vm.show = true;
    }

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
