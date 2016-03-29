(function(){

  'use strict';

  angular
    .module('thatsaboy.family.familyFactory',
      ['thatsaboy.common.resourceWrapFactory'])
    .factory('familyFactory', familyFactory);

  familyFactory.$inject = ['resourceWrapFactory'];

  function familyFactory(resourceWrapFactory){

    var familyResource = resourceWrapFactory.wrap('/api/v1/family/');

    function view() {
      return familyResource.get({});
    }

    function update(name, photo_url) {
      return familyResource.update({"name": name, "photo_url": photo_url});
    }

    return {
        view    : view,
        update  : update
    }
  }

})();