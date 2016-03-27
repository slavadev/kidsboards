(function () {
  'use strict';

  angular
    .module('thatsaboy.family.familyController',
      [
        'thatsaboy.family.familyFactory'
      ]
    ).controller('familyController', familyController);

  familyController.$inject = ['familyFactory', 'family'];

  function familyController(familyFactory, family) {
    var vm = this;
    vm.family = family;
    return vm;
  }

})();