(function () {

  'use strict';

  angular
    .module('kidsboards.children')
    .factory('childRepository', childRepository);

  childRepository.$inject = ['resourceWrapService'];

  function childRepository(resourceWrapService) {

    var childResource = resourceWrapService.wrap('family/child/:id/:action');

    function create(name, photo_url) {
      return childResource.save({name: name, photo_url: photo_url});
    }

    function update(id, name, photo_url) {
      return childResource.update({id: id, name: name, photo_url: photo_url});
    }

    function remove(id) {
      return childResource.delete({id: id});
    }

    function getGoals(id) {
      return childResource.query({id: id, action: 'goal'}).then(function(response){
        return response;
      });
    }

    function createGoal(id, name, photo_url, target) {
      return childResource.save({id: id, action: 'goal', name: name, photo_url: photo_url, target: target});
    }

    return {
      create    : create,
      update    : update,
      remove    : remove,
      getGoals  : getGoals,
      createGoal: createGoal
    }
  }

})();