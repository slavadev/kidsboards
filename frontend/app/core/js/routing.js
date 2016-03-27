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
    }).state('app.family', {
      url: "/family",
      views: {
        'content': {
          controller: "familyController",
          controllerAs: "familyCtrl",
          templateUrl: "/app/modules/family/templates/family.html",
          resolve: {
            family: function (familyFactory) {
              return familyFactory.view();
            }
          }
        }
      }
    });

  }


})();