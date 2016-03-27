(function () {
    'use strict';

    angular
        .module('thatsaboy.index.indexController',
            [
                'thatsaboy.common.loginFactory'
            ]
        ).controller('indexController', indexController);

    indexController.$inject = ['loginFactory'];
    
    function indexController(loginFactory) {
        var vm = this;
        vm.login = function () {
            loginFactory.login(vm.email, vm.password).then(function (token) {
                console.log(token)
            }, function (response) {
                vm.errorMessage = response.data;
                console.log(response)
            })
        };
        vm.register = function () {
            loginFactory.register(vm.email, vm.password).then(function (token) {
                console.log(token)
            }, function (response) {
                vm.errorMessage = response.data;
                console.log(response)
            })
        };

        return vm;
    };

})();
