(function () {
  'use strict';

  angular
    .module('kidsboards.adults')
    .controller('adultController', adultController);

  adultController.$inject = ['adultRepository', 'adult', '$state'];

  function adultController(adultRepository, adult, $state) {
    if(!adult) {
      $state.go('app.family');
    }

    var vm = this;
    vm.adult = adult;
    vm.update = function(){
      return adultRepository.update(vm.adult.id, vm.adult.name, vm.adult.photo_url);
    };
    vm.delete = function(){
      adultRepository.remove(vm.adult.id).then(function(){
        $state.go('app.family');
      });
    };
    return vm;
  }

})();