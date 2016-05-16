(function () {
  'use strict';
  
  angular
    .module('thatsaboy.common')
    .directive('setPin', setPin);

  setPin.$inject = ['$rootScope', 'loginService'];

  function setPin($rootScope, loginService) {

    return {
      restrict: 'E',
      replace: true,
      templateUrl: '/app/modules/common/templates/set-pin.html',
      link    : function ($scope, element, attrs, ctrl) {
        console.log('asd');
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
                $rootScope.$emit('nextStep');
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