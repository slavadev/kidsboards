(function () {

  'use strict';

  angular
    .module('thatsaboy.adults')
    .factory('adultRepository', adultRepository);

  adultRepository.$inject = ['resourceWrapService'];

  function adultRepository(resourceWrapService) {

    var adultResource = resourceWrapService.wrap('family/adult/:id');

    function create(name, photo_url) {
      return adultResource.save({name: name, photo_url: photo_url});
    }

    function update(id, name, photo_url) {
      return adultResource.update({id: id, name: name, photo_url: photo_url});
    }

    function remove(id) {
      return adultResource.delete({id: id});
    }

    return {
      create: create,
      update: update,
      remove: remove
    }
  }

})();