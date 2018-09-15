(function () {
  'use strict';

  angular.module('kidsboards.common')
    .factory('apiLinkService', apiLinkService);


  apiLinkService.$inject = ['$location'];

  function apiLinkService($location) {
    function createUrl(link){
      var host = '';
      switch ($location.host()) {
        case 'kidsboards.local':
          host = 'http://api.kidsboards.local/';
          break;
        default :
          host = 'https://kidsboards-api.herokuapp.com/';
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
