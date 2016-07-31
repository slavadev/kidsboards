(function () {
  'use strict';
  
  angular
    .module('thatsaboy.common')
    .directive('leftPanel', leftPanel);

  leftPanel.$inject = ['$timeout'];

  function leftPanel($timeout) {
    return {
      restrict: 'E',
      replace: true,
      transclude: true,
      templateUrl: '/app/modules/common/templates/left-panel.html',
      controller: ['$scope', function ($scope) {
        $scope.panelClosed = true;
        $scope.togglePanel = function(){
          $timeout(function () {
            $scope.panelClosed = !$scope.panelClosed;
          }, 10);
        };
      }]
    };
  }
})();