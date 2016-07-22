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
          $scope.pin = '';
          $scope.mode = 'login';
          delete $scope.error;
        };
        $scope.showChangePinDialog = function(){
          $scope.pin = '';
          $scope.mode = 'change';
        };
        $scope.closeLoginDialog = function(){
          $scope.mode = 'view';
        };
        $scope.login = function() {
          loginService.enterAdultMode($scope.pin).then(function(equals){
            $scope.pin = '';
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


        // change password part
        $scope.change_step = 1;
        $scope.change_text = 'Set up a PIN code';
        var pin1 = '';

        $scope.change_next = function(){
          if ($scope.change_step == 1) {
            pin1 = $scope.pin;
            $scope.pin = '';
            $scope.change_step = 2;
            $scope.change_text = 'Repeat the PIN code';
          } else {
            if(pin1 == $scope.pin) {
              loginService.setPin($scope.pin).then(function(){
                $scope.mode = 'view';
                $scope.change_step = 1;
                $scope.change_text = 'Set up a PIN code';
              });
            } else {
              $scope.change_step = 1;
              $scope.pin = '';
              $scope.change_text = 'Set up a PIN code';
            }
          }
        };
      }
    };
  }
})();