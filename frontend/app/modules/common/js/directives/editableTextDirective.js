(function () {
  'use strict';
  
  angular
    .module('thatsaboy.common')
    .directive('editableText', editableText);

  editableText.$inject = ['$rootScope'];

  function editableText($rootScope) {

    return {
      restrict: 'A',
      replace: false,
      templateUrl: '/app/modules/common/templates/editable-text.html',
      scope: {
        editableText: '=',
        updateMethod: '&',
        onlyEdit: '@'
      },
      link    : function ($scope, element, attrs, ctrl) {

        $scope.onlyEdit = $scope.onlyEdit ? true : false;
        $scope.mode = $scope.onlyEdit ? 'edit' : 'view';
        var text = '';

        $scope.turnOnEditMode = function(){
          $scope.mode = 'edit';
          text = $scope.editableText;
        };
        
        $scope.saveText = function(){
          $scope.updateMethod().then(function(){
            if($scope.onlyEdit) {
              $rootScope.$emit('nextStep');
            } else {
              $scope.mode = 'view';
            }
          });
        };

        $scope.cancel = function(){
          $scope.editableText = text;
          $scope.mode = 'view';
        };
      }
    };
  }
})();