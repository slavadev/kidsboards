(function () {
  'use strict';

  angular
    .module('thatsaboy.common')
    .directive('numPad', numPad);

  numPad.$inject = ['$document'];

  function numPad($document) {

    return {
      restrict   : 'E',
      replace    : true,
      scope      : {
        num     : '=',
        text    : '@',
        min     : '@',
        max     : '@',
        type    : '@',
        onlyOk  : '@',
        onOk    : '&',
        onCancel: '&'
      },
      templateUrl: '/app/modules/common/templates/num-pad.html',
      link       : function ($scope, element, attrs, ctrl) {
        if (!$scope.type) {
          $scope.type = 'text';
        }
        $scope.num     = '';
        $scope.buttons = ['1', '2', '3', '4', '5', '6', '7', '8', '9', 'C', '0', 'DEL'];

        $scope.lengthIsOk = function () {
          return $scope.num.length >= $scope.min && $scope.num.length <= $scope.max;
        };

        $scope.canPress = function () {
          return $scope.num.length < $scope.max;
        };

        $scope.press = function (button) {
          switch (button) {
            case 'C':
              $scope.num = '';
              break;
            case 'DEL':
              $scope.num = $scope.num.slice(0, -1);
              break;
            default:
              if ($scope.canPress()) {
                $scope.num = $scope.num + button;
              }
          }
        };

        $scope.$watch(function () {
          return element.hasClass('ng-hide');
        }, function (nv) {
          if (nv == false) {
            $document.unbind('keydown').bind('keydown', function (event) {
              if (event.keyCode === 8) {
                event.preventDefault();
                $scope.press('DEL')
              }
              if (event.keyCode === 13) {
                $scope.ok();
              }
              if(event.keyCode >= 48 && event.keyCode <= 57) {
                var key = (event.keyCode - 48).toString();
                $scope.press(key);
              }
              $scope.$apply();
            });
          }
          if (nv == true) {
            $document.unbind('keydown');
          }
        });


        function getHeight() {
          return element[0].offsetHeight;
        }

        $scope.ok = function () {
          if ($scope.lengthIsOk) {
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