(function () {
  'use strict';

  angular.module('thatsaboy.common')
    .factory('apiLinkService', apiLinkService);


  apiLinkService.$inject = ['$location'];

  function apiLinkService($location) {
    function createUrl(link){
      var host = '';
      switch ($location.host()) {
        case 'thatsaboy.dev':
          host = 'http://api.thatsaboy.dev/';
          break;
        default :
          host = 'http://api.thatsaboy.com/';
          break;
      }

      // current version
      host = host + 'v1/';

      return host + link;
    }

    return {
      /**
       * Add API host to a link
       * @return {String}
       */
      createUrl: createUrl

    };
  }
})();