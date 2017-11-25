(function () {
  'use strict';

  angular
    .module('kidsboards.common')
    .factory('resourceWrapService', resourceWrapService);

  resourceWrapService.$inject = ['$resource', 'localStorageService', 'errorHandlerService', 'apiLinkService'];

  function resourceWrapService($resource, localStorageService, errorHandlerService, apiLinkService) {

    function getToken() {
      return localStorageService.get("token");
    }

    function _successFunction(response) {
      return response;
    }

    function wrapAction(resource, action, params, object) {
      var errorHandler = errorHandlerService.basicErrorHandler;
      if (params) {
        params.token = getToken();
        if (params.errorHandler){
          errorHandler = params.errorHandler;
          params.errorHandler = null;
        }
      }
      if (object) {
        return resource[action](params, object).$promise.then(_successFunction, errorHandler);
      }
      return resource[action](params).$promise.then(_successFunction, errorHandler);
    }

    return {
      wrap: function (url) {
        var resource = $resource(apiLinkService.createUrl(url),
          {
            id: '@id',
            action: '@action',
            token: '@token'
          }, {
            'update': {
              method: 'PUT'
            },
            'patch': {
              method: 'PATCH'
            },
            'remove': {
              method: 'DELETE'
            }
          }
        );

        return {
          'get': function (params, object) {
            return wrapAction(resource, 'get', params, object);
          },
          'save': function (params, object) {
            return wrapAction(resource, 'save', params, object);
          },
          'post': function (params, object) {
            return wrapAction(resource, 'save', params, object);
          },
          'query': function (params, object) {
            return wrapAction(resource, 'query', params, object);
          },
          'update': function (params, object) {
            return wrapAction(resource, 'update', params, object);
          },
          'put': function (params, object) {
            return wrapAction(resource, 'update', params, object);
          },
          'patch': function (params, object) {
            return wrapAction(resource, 'patch', params, object);
          },
          'delete': function (params, object) {
            return wrapAction(resource, 'remove', params, object);
          }
        }
      }
    }
  }

})
();