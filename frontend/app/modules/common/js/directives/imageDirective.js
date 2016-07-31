(function () {
  'use strict';

  angular
    .module('thatsaboy.common')
    .directive('image', image);

  image.$inject = [];

  function image() {

    return {
      restrict  : 'A',
      scope     : {
        image: '='
      },
      controller: ['$scope', function ($scope) {
        $scope.$watch('image', onAttrChange);

        function onAttrChange() {
          if (($scope.image !== undefined)) {
            loadImage($scope._element, $scope.image);
          }
        }

        /* global Image */
        function loadImage(element, src) {

          var imageObj    = new Image();
          imageObj.src    = src;
          imageObj.onload = function () {
            angular.element(element).css('background-image', 'url(' + src + ")");
            angular.element(element).addClass('loaded');
            angular.element(imageObj).remove();
          };
        }


      }],
      link      : {
        post: function (scope, element, attrs) {

          scope.$eval(
            function (scope) {
              scope._element = element;
            }
          );
        }
      }
    };
  }
})();