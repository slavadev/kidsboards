(function () {
  'use strict';

  angular
    .module('thatsaboy.family')
    .controller('familyController', familyController);

  familyController.$inject = ['familyRepository', 'family'];

  function familyController(familyRepository, family) {
    var vm = this;
    vm.family = family;
    vm.update = function(){
      return familyRepository.update(vm.family.name, vm.family.photo_url);
    };
    return vm;
  }

})();