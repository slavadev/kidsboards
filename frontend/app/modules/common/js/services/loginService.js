(function () {
  'use strict';

  angular.module('thatsaboy.common')
    .factory('loginService', loginService);


  loginService.$inject = [
    'resourceWrapService',
    'localStorageService',
    'errorHandlerService',
    '$q'
  ];

  function loginService(resourceWrapService, localStorageService, errorHandlerService, $q) {

    exitAdultMode();

    var loginResource = resourceWrapService.wrap('/api/v1/user/:action');

    function register(email, password) {
      return loginResource.post({
        action  : 'register',
        email   : email,
        password: password
      }).then(function (response) {
        return login(email, password);
      });
    }

    function login(email, password) {
      return loginResource.post({
        action  : 'login',
        email   : email,
        password: password
      }).then(function (response) {
        var token = response.token;
        localStorageService.set("token", token);
        return token;
      });
    }

    function requestRecovery(email) {
      return loginResource.post({
        action: 'request',
        email : email
      }).then(function (response) {
        return response;
      });
    }

    function recovery(password, token) {
      localStorageService.set("token", token);
      return loginResource.post({
        action  : 'recovery',
        password: password,
        errorHandler: errorHandlerService.recoveryErrorHandler
      }).then(function (response) {
        return response;
      });
    }

    function logout() {
      localStorageService.remove("token");
      return $q.when();
    }

    function getToken() {
      return localStorageService.get("token");
    }

    function setPin(pin) {
      return loginResource.patch({
        action: 'pin',
        pin   : pin,
        token : getToken()
      });
    }

    function enterAdultMode(pin) {
      return loginResource.get({
        action: 'pin',
        pin   : pin,
        token : getToken()
      }).then(function (response) {
        var equal = response.data.equal;
        if (equal == true) {
          localStorageService.set("adult-mode", true);
        }
        return equal;
      });
    }

    function forceAdultMode() {
      localStorageService.set("adult-mode", true);
      return $q.when();
    }

    function exitAdultMode() {
      localStorageService.remove("adult-mode");
      return $q.when();
    }

    function isAdultMode() {
      return !!localStorageService.get("adult-mode");
    }


    return {
      getToken       : getToken,
      login          : login,
      logout         : logout,
      register       : register,
      requestRecovery: requestRecovery,
      recovery       : recovery,
      // Adult mode
      setPin         : setPin,
      enterAdultMode : enterAdultMode,
      exitAdultMode  : exitAdultMode,
      isAdultMode    : isAdultMode,
      forceAdultMode : forceAdultMode
    }
  }
})();