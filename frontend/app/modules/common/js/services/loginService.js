(function () {
  'use strict';

  angular.module('thatsaboy.common')
    .factory('loginService', loginService);


  loginService.$inject = [
    '$http',
    'localStorageService',
    '$q'
  ];

  function loginService($http, localStorageService, $q) {

    function register(email, password) {
      return $http.post('/api/v1/user/register', {
        email   : email,
        password: password
      }).then(function (response) {
        return login(email, password);
      });
    }

    function login(email, password) {
      return $http.post('/api/v1/user/login', {
        email   : email,
        password: password
      }).then(function (response) {
        var token = response.data.token;
        localStorageService.set("token", token);
        return token;
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
      return $http.patch('/api/v1/user/pin', {
        pin  : pin,
        token: getToken()
      });
    }

    function enterAdultMode(pin) {
      return $http.get('/api/v1/user/pin?pin=' + pin + '&token=' + getToken())
        .then(function (response) {
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
      getToken      : getToken,
      login         : login,
      logout        : logout,
      register      : register,
      // Adult mode
      setPin        : setPin,
      enterAdultMode: enterAdultMode,
      exitAdultMode : exitAdultMode,
      isAdultMode   : isAdultMode,
      forceAdultMode: forceAdultMode
    }
  }
})();