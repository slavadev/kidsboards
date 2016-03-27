(function () {
  'use strict';
  angular.module('thatsaboy')
    .config(routing);

  routing.$inject = ['$stateProvider', '$urlRouterProvider'];
  function routing($stateProvider, $urlRouterProvider) {

    $urlRouterProvider.otherwise('/app/index');

    $stateProvider
      .state('app', {
      url: "/app",
      templateUrl: "/app/core/templates/app.html",
      abstract: true
    }).state('app.index', {
      url: "/index",
      views: {
        'content': {
          controller: "indexController",
          controllerAs: "indexCtrl",
          templateUrl: "/app/modules/index/templates/index.html"
        }
      }
    });

  }


})();