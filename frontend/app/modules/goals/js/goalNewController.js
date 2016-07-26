(function () {
  'use strict';

  angular
    .module('thatsaboy.goals')
    .controller('goalNewController', goalNewController);

  goalNewController.$inject = ['childRepository', 'loginService', '$scope', '$state', '$q', '$stateParams'];

  function goalNewController(childRepository, loginService, $scope, $state, $q, $stateParams) {
    var vm = this;
    loginService.forceAdultMode();
    vm.id = $stateParams.id;
    vm.step = 1;
    vm.name = '';
    vm.nothing = function(){
      return $q.when();
    };
    vm.create = function(){
      childRepository.createGoal(vm.id, vm.name, vm.photo_url, vm.target).then(function(){
        $state.go('app.child', {id: vm.id});
      });
    };
    $scope.$on('nextStep', function () {
      vm.step = vm.step + 1;
    });
    return vm;
  }

})();