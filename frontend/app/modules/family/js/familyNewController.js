(function () {
  'use strict';

  angular
    .module('thatsaboy.family')
    .controller('familyNewController', familyNewController);

  familyNewController.$inject = ['familyRepository', 'loginService', '$rootScope', '$state'];

  function familyNewController(familyRepository, loginService, $rootScope, $state) {
    var vm = this;
    loginService.forceAdultMode();
    vm.step = 1;
    vm.name = 'New family';
    vm.update = function(){
      return familyRepository.update(vm.name, vm.photo_url);
    };
    $rootScope.$on('nextStep', function () {
      if (vm.step < 3) {
        vm.step = vm.step + 1;
      } else {
        $state.go('app.family');
      }
    });
    return vm;
  }

})();