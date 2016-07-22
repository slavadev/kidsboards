(function () {
  'use strict';

  angular
    .module('thatsaboy.common')
    .directive('editableImage', editableImage);

  editableImage.$inject = ['photoUploadService', '$http', '$q', '$timeout'];

  function editableImage(photoUploadService, $http, $q, $timeout) {

    return {
      restrict   : 'A',
      replace    : false,
      templateUrl: '/app/modules/common/templates/editable-image.html',
      scope      : {
        editableImage: '=',
        updateMethod : '&',
        imageBanks   : '=',
        onlyEdit     : '@',
        text        : '@'
      },
      link       : function ($scope, element, attrs, ctrl) {
        $scope.onlyEdit = $scope.onlyEdit ? true : false;
        $scope.images = [];

        // load images
        var imageBankPromises = [];
        angular.forEach($scope.imageBanks, function (bank) {
          var imagePromise = $http.get('/json/' + bank + '.json').then(function (response) {
            angular.forEach(response.data, function (image) {
              $scope.images.push({url: image});
            });
          });
          imageBankPromises.push(imagePromise);
        });
        $q.all(imageBankPromises).then(function () {
          photoUploadService.index().then(function (photos) {
            angular.forEach(photos, function (photo) {
              $scope.images.push(photo);
            });
          })
        });

        $scope.mode = $scope.onlyEdit ? 'edit' : 'view';

        $scope.turnOnEditMode = function () {
          $scope.mode = 'edit';
        };

        $scope.uploadFile = function (file) {
          photoUploadService.upload(file).then(function (photo) {
            $scope.images.push(photo);
          });
        };

        $scope.deleteImage = function (image) {
          photoUploadService.remove(image.id).then(function () {
            var index = $scope.images.indexOf(image);
            $scope.images.splice(index, 1);
          })
        };

        $scope.chooseImage = function (image) {
          $scope.editableImage = image.url;
          $timeout(
            function () {
              $scope.updateMethod().then(function () {
                if($scope.onlyEdit) {
                  $scope.$emit('nextStep');
                } else {
                  $scope.mode = 'view';
                }
              })
            });
        };

        $scope.cancel = function () {
          $scope.mode = 'view';
        };
      }
    };
  }
})();