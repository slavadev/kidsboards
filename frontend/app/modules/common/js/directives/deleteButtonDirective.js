(function () {
  'use strict';
  
  angular
    .module('thatsaboy.common')
    .directive('deleteButton', deleteButton);

  deleteButton.$inject = ['$mdDialog'];

  function deleteButton($mdDialog) {

    return {
      restrict: 'E',
      replace: true,
      templateUrl: '/app/modules/common/templates/delete-button.html',
      scope: {
        'action': '&'
      },
      controller: ['$scope', function($scope) {
        $scope.delete = function(ev) {
          var confirm = $mdDialog.confirm()
            .title('Are you sure?')
            .textContent('This action cannot be undone.')
            .targetEvent(ev)
            .ok('Yes')
            .cancel('No');
          $mdDialog.show(confirm).then(function() {
            $scope.action();
          }, function() {
          });
        };
      }]
    };
  }
})();