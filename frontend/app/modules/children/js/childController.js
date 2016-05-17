(function () {
  'use strict';

  angular
    .module('thatsaboy.children')
    .controller('childController', childController);

  childController.$inject = ['childRepository', 'child', '$state'];

  function childController(childRepository, child, $state) {
    if(!child) {
      $state.go('app.family');
    }

    var vm = this;
    vm.child = child;
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