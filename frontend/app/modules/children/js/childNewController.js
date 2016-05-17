(function () {
  'use strict';

  angular
    .module('thatsaboy.children')
    .controller('childNewController', childNewController);

  childNewController.$inject = ['childRepository', 'loginService', '$scope', '$state', '$q'];

  function childNewController(childRepository, loginService, $scope, $state, $q) {
    var vm = this;
    loginService.forceAdultMode();
    vm.step = 1;
    vm.name = 'Child';
    vm.nothing = function(){
      return $q.when();
    };
    vm.create = function(){
      return childRepository.create(vm.name, vm.photo_url);
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