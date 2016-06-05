(function () {
  'use strict';

  angular
    .module('thatsaboy.common')
    .factory('resourceWrapService', resourceWrapService);

  resourceWrapService.$inject = ['$resource', 'localStorageService', '$state', 'errorHandlerService', '$q'];

  function resourceWrapService($resource, localStorageService, $state, errorHandlerService, $q) {

    function logout() {
      localStorageService.remove("token");
      return $q.when();
    }

    function getToken() {
      return localStorageService.get("token");
    }

    function _successFunction(responce) {
      return responce;
    }

    function _errorFunction(responce) {
      if (responce.status == 401) {
        logout();
        $state.go('app.index');
        return '401';
      } else if (responce.status == 403) {
        return '403';
      } else if (responce.status == 422) {
        errorHandlerService.handle422(responce.data);
      } else if (responce.status == 500) {
        return '500';
      }
      return;
    }

    function wrapAction(resource, action, params, object) {
      var errorHandler = _errorFunction;
      if (params) {
        params.token = getToken();
        if (params.errorHandler){
          errorHandler = function(responce) {
            _errorFunction(responce);
            params.errorHandler(responce);
          };
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
        var resource = $resource(url,
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