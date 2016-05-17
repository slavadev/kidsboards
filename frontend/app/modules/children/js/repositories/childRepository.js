(function () {

  'use strict';

  angular
    .module('thatsaboy.children')
    .factory('childRepository', childRepository);

  childRepository.$inject = ['resourceWrapService'];

  function childRepository(resourceWrapService) {

    var childResource = resourceWrapService.wrap('/api/v1/family/child/:id');

    function create(name, photo_url) {
      return childResource.save({name: name, photo_url: photo_url});
    }

    function update(id, name, photo_url) {
      return childResource.update({id: id, name: name, photo_url: photo_url});
    }

    function remove(id) {
      return childResource.delete({id: id});
    }

    return {
      create: create,
      update: update,
      remove: remove
    }
  }

})();