(function () {
  'use strict';
  
  angular
    .module('thatsaboy.common')
    .directive('use', svgInlineDirective);

  svgInlineDirective.$inject = ['$window', '$rootScope', '$timeout'];
  /* global navigator */
  function svgInlineDirective($window, $rootScope, $timeout) {

    return {
      restrict: 'E',
      link    : function ($scope, element, attrs, ctrl) {

        function updateHref() {
          var baseUrl  = $window.location.href
            .replace($window.location.hash, "");
          var hrefHash = attrs.xlinkHref.substring(attrs.xlinkHref.search('#'));
          var fullUrl  = baseUrl + hrefHash;
          if (attrs.xlinkHref !== fullUrl) {

            element.attr('xlink:href', fullUrl);
          }
        }

        // CHROME is respecting base tag from v.49,
        // so we enable it for all browsers
        attrs.$observe('xlinkHref', updateHref);
        // recheck urls on location update
        $rootScope.$on('$locationChangeSuccess', function () {
          $timeout(updateHref);
        });
      }
    };
  }
})();