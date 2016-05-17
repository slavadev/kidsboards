(function () {
  'use strict';
  
  angular
    .module('thatsaboy.common')
    .directive('setPin', setPin);

  setPin.$inject = ['loginService'];

  function setPin(loginService) {

    return {
      restrict: 'E',
      replace: true,
      templateUrl: '/app/modules/common/templates/set-pin.html',
      link    : function ($scope, element, attrs, ctrl) {
        $scope.step = 1;
        $scope.pin = '';
        var pin1 = '';

        $scope.next = function(){
          if ($scope.step == 1) {
            pin1 = $scope.pin;
            $scope.pin = '';
            $scope.step = 2;
          } else {
            if(pin1 == $scope.pin) {
              loginService.setPin($scope.pin).then(function(){
                $scope.$emit('nextStep');
              });
            } else {
              $scope.step = 1;
              $scope.pin = '';
            }
          }
        };
      }
    };
  }
})();