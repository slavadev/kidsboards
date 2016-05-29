(function () {
  'use strict';

  angular
    .module('thatsaboy.goals')
    .controller('goalController', goalController);

  goalController.$inject = ['goalRepository', 'goal', 'adults', '$state', '$stateParams'];

  function goalController(goalRepository, goal, adults, $state, $stateParams) {
    var vm = this;
    vm.step = 1;
    vm.child_id = $stateParams.child_id;
    if(!goal) {
      $state.go('app.child', {id: vm.child_id});
    }
    vm.goal = goal;
    vm.adults = adults;
    vm.update = function(){
      return goalRepository.update(vm.goal.id, vm.goal.name, vm.goal.photo_url);
    };
    vm.delete = function(){
      goalRepository.remove(vm.goal.id).then(function(){
        $state.go('app.child', {id: vm.child_id});
      });
    };
    vm.add = function(){
      vm.step = 2;
      vm.mode = 'add'
    };
    vm.remove = function(){
      vm.step = 2;
      vm.mode = 'remove'
    };
    vm.chooseAdult = function (adult) {
      vm.adult_id = adult.id;
      vm.step = 3;
    };
    vm.updatePoints = function(){
      var diff = vm.mode == 'add' ? vm.points : -vm.points;
      goalRepository.updatePoints(vm.goal.id, diff, vm.adult_id).then(function(){
        return goalRepository.get(vm.goal.id);
      }).then(function(goal){
        vm.goal = goal;
        vm.step = 1;
      });
    };
    return vm;
  }

})();