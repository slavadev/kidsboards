(function () {
  'use strict';

  angular.module('kidsboards.common')
    .factory('photoUploadService', photoUploadService);


  photoUploadService.$inject = [
    'loginService',
    'Upload',
    '$http',
    'apiLinkService'
  ];

  function photoUploadService(loginService, Upload, $http, apiLinkService) {

    var url = apiLinkService.createUrl('uploaded/photo');

    function upload(file) {
      return Upload.upload({
        url : url,
        data: {file: file, token: loginService.getToken()}
      }).then(function (response) {
        return response.data;
      })
    }

    function index() {
      return $http.get(url +'?token=' + loginService.getToken()).then(function(response){
        return response.data;
      });
    }

    function remove(id) {
      return $http.delete(url + '/' + id +'?token=' + loginService.getToken())
    }

    return {
      upload: upload,
      index : index,
      remove: remove
    }
  }
})();