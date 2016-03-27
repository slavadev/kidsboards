(function () {
  //'use strict';
  angular.module('thatsaboy.common.loginFactory', [])
    .factory('loginFactory', loginFactory);


  loginFactory.$inject = [
    '$http',
    'localStorageService'
  ];

  function loginFactory ($http, localStorageService) {

    function register(email, password){
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
    }

    function getToken() {
      return localStorageService.get("token");
    }


    return {
      getToken: getToken,
      login   : login,
      logout  : logout,
      register: register
    }
  }
})();