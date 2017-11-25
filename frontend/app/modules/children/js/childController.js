(function () {
  'use strict';

  angular
    .module('kidsboards.children')
    .controller('childController', childController);

  childController.$inject = ['childRepository', 'child', 'goals', '$state'];

  function childController(childRepository, child, goals, $state) {
    if(!child) {
      $state.go('app.family');
    }

    var vm = this;
    vm.child = child;
    vm.goals = goals;
    vm.update = function(){
      return childRepository.update(vm.child.id, vm.child.name, vm.child.photo_url);
    };
    vm.delete = function(){
      childRepository.remove(vm.child.id).then(function(){
        $state.go('app.family');
      });
    };
    return vm;
  }

})();