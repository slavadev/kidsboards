(function () {
  'use strict';
  
  angular
    .module('thatsaboy.common')
    .directive('editableText', editableText);

  editableText.$inject = [];

  function editableText() {

    return {
      restrict: 'A',
      replace: false,
      templateUrl: '/app/modules/common/templates/editable-text.html',
      scope: {
        editableText: '=',
        updateMethod: '&'
      },
      link    : function ($scope, element, attrs, ctrl) {
        $scope.mode = 'view';
        var text = '';

        $scope.turnOnEditMode = function(){
          $scope.mode = 'edit';
          text = $scope.editableText;
        };
        
        $scope.saveText = function(){
          $scope.updateMethod().then(function(){
            $scope.mode = 'view';
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