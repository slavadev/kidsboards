(function () {
  'use strict';
  angular.module('thatsaboy')
    .config(routing);

  routing.$inject = ['$stateProvider', '$urlRouterProvider'];
  function routing($stateProvider, $urlRouterProvider) {

    $urlRouterProvider.otherwise('/');

    $stateProvider.state('index', {
      url: "/",
      templateUrl: "/app/modules/index/templates/index.html"
    })
      .state('app', {
      url: "/app",
      templateUrl: "/app/core/templates/app.html",
      abstract: true
    }).state('app.index', {
      url: "/index",
      views: {
        'content': {
          templateUrl: "/app/modules/index/templates/index.html"
        }
      }
    });

  }


})();