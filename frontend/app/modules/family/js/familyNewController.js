(function () {
  'use strict';

  angular
    .module('thatsaboy.family')
    .controller('familyNewController', familyNewController);

  familyNewController.$inject = ['familyRepository', 'loginService', '$scope', '$state', '$timeout'];

  function familyNewController(familyRepository, loginService, $scope, $state, $timeout) {
    var vm = this;
    loginService.forceAdultMode();
    vm.step = 0;
    $timeout(function () {
      vm.step = 1;
    }, 2000);
    vm.name = '';
    vm.update = function(){
      return familyRepository.update(vm.name, vm.photo_url);
    };
    $scope.$on('nextStep', function () {
      if (vm.step < 3) {
        vm.step = vm.step + 1;
      } else {
        $state.go('app.family');
      }
    });
    return vm;
  }

})();