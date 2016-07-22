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
      vm.step = vm.step + 1;
    });


    // change password part
    $scope.change_step = 1;
    $scope.pin = '';
    $scope.change_text = 'Set up a PIN code';
    var pin1 = '';

    $scope.change_next = function(){
      if ($scope.change_step == 1) {
        pin1 = $scope.pin;
        $scope.pin = '';
        $scope.change_step = 2;
        $scope.change_text = 'Repeat the PIN code';
      } else {
        if(pin1 == $scope.pin) {
          loginService.setPin($scope.pin).then(function(){
            $state.go('app.family');
          });
        } else {
          $scope.change_step = 1;
          $scope.pin = '';
          $scope.change_text = 'Set up a PIN code';
        }
      }
    };



    return vm;
  }

})();