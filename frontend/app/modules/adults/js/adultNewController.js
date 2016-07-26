(function () {
  'use strict';

  angular
    .module('thatsaboy.adults')
    .controller('adultNewController', adultNewController);

  adultNewController.$inject = ['adultRepository', 'loginService', '$scope', '$state', '$q'];

  function adultNewController(adultRepository, loginService, $scope, $state, $q) {
    var vm = this;
    loginService.forceAdultMode();
    vm.step = 1;
    vm.name = '';
    vm.nothing = function(){
      return $q.when();
    };
    vm.create = function(){
      return adultRepository.create(vm.name, vm.photo_url);
    };
    $scope.$on('nextStep', function () {
      if (vm.step < 2) {
        vm.step = vm.step + 1;
      } else {
        $state.go('app.family');
      }
    });
    return vm;
  }

})();