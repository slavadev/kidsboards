(function () {
  'use strict';
  
  angular
    .module('kidsboards.common')
    .directive('logout', logout);

  logout.$inject = ['loginService', '$state'];

  function logout(loginService, $state) {

    return {
      restrict: 'E',
      replace: true,
      templateUrl: '/app/modules/common/templates/logout.html',
      link    : function ($scope, element, attrs, ctrl) {
        $scope.logout = function(){
          loginService.logout().then(function(){
            loginService.exitAdultMode();
            $state.go('app.index');
          });
        }
      }
    };
  }
})();