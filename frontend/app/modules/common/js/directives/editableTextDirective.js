(function () {
  'use strict';
  
  angular
    .module('kidsboards.common')
    .directive('editableText', editableText);

  editableText.$inject = ['$timeout'];

  function editableText($timeout) {

    return {
      restrict: 'A',
      replace: false,
      templateUrl: '/app/modules/common/templates/editable-text.html',
      scope: {
        editableText: '=',
        updateMethod: '&',
        onlyEdit: '@',
        label: '@',
        text: '@'
      },
      link    : function ($scope, element, attrs, ctrl) {

        $scope.label = $scope.label ? $scope.label : 'save';
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
              $scope.$emit('nextStep');
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