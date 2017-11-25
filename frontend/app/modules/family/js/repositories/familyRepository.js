(function(){

  'use strict';

  angular
    .module('kidsboards.family')
    .factory('familyRepository', familyRepository);

  familyRepository.$inject = ['resourceWrapService'];

  function familyRepository(resourceWrapService){

    var familyResource = resourceWrapService.wrap('family/');

    function get() {
      return familyResource.get({});
    }

    function update(name, photo_url) {
      return familyResource.update({"name": name, "photo_url": photo_url});
    }

    return {
        get     : get,
        update  : update
    }
  }

})();