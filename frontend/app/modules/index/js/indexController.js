(function () {
    'use strict';

    angular
        .module('thatsaboy.index')
      .controller('indexController', indexController);

    indexController.$inject = ['loginService', '$state'];
    
    function indexController(loginService, $state) {
        var vm = this;
        vm.login = function () {
            loginService.login(vm.email, vm.password).then(function (token) {
               $state.go('app.family');
            }, function (response) {
                vm.errorMessage = response.data;
                console.log(response);
            })
        };
        vm.register = function () {
            loginService.register(vm.email, vm.password).then(function (token) {
                $state.go('app.family_new');
            }, function (response) {
                vm.errorMessage = response.data;
                console.log(response);
            })
        };

        return vm;
    };

})();
