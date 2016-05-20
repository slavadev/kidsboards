(function () {
  'use strict';
  
  angular
    .module('thatsaboy.common')
    .directive('numPad', numPad);

  numPad.$inject = [];

  function numPad() {

    return {
      restrict: 'E',
      replace: true,
      scope: {
        num: '=',
        text: '@',
        min: '@',
        max: '@',
        onlyOk: '@',
        onOk: '&',
        onCancel: '&'
      },
      templateUrl: '/app/modules/common/templates/num-pad.html',
      link    : function ($scope, element, attrs, ctrl) {
        $scope.ok = function () {
          if($scope.num.length >= $scope.min && $scope.num.length <= $scope.max) {
            $scope.onOk();
          }
        };
        
        $scope.cancel = function () {
          $scope.onCancel();
        }
      }
    };
  }
})();