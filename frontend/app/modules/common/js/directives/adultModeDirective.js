(function () {
  'use strict';
  
  angular
    .module('thatsaboy.common')
    .directive('adultMode', adultMode);

  adultMode.$inject = ['loginService', '$timeout'];

  function adultMode(loginService, $timeout) {
    return {
      restrict: 'E',
      replace: true,
      templateUrl: '/app/modules/common/templates/adult-mode.html',
      link    : function ($scope, element, attrs, ctrl) {
        $scope.mode = 'view';
        $scope.exitAdultMode = loginService.exitAdultMode;

        $scope.showLoginDialog = function(){
          $scope.mode = 'login';
          delete $scope.error;
        };
        $scope.showChangePinDialog = function(){
          $scope.mode = 'change';
        };
        $scope.closeLoginDialog = function(){
          $scope.mode = 'view';
        };
        $scope.login = function() {
          loginService.enterAdultMode($scope.pin).then(function(equals){
            if(equals == true) {
              $scope.mode = 'view';
            } else {
              $scope.error = true;
              $timeout(function(){
                delete $scope.error;
              },3000);
            }
          });
        };
        $scope.changePin = function() {
          loginService.setPin($scope.pin).then(function(){
            $scope.mode = 'view';
          });
        };
      }
    };
  }
})();