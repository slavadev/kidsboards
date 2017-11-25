(function () {

  'use strict';

  angular
    .module('kidsboards.goals')
    .factory('goalRepository', goalRepository);

  goalRepository.$inject = ['resourceWrapService'];

  function goalRepository(resourceWrapService) {

    var goalResource = resourceWrapService.wrap('goal/:id/:action');

    function get(id) {
      return goalResource.get({id: id});
    }

    function update(id, name, photo_url) {
      return goalResource.update({id: id, name: name, photo_url: photo_url});
    }

    function updatePoints(id, diff, adult_id) {
      return goalResource.patch({action: 'points', id: id, diff: diff, adult_id: adult_id});
    }

    function remove(id) {
      return goalResource.delete({id: id});
    }

    return {
      get         : get,
      update      : update,
      remove      : remove,
      updatePoints: updatePoints
    }
  }

})();