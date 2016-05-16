(function () {
  'use strict';

  /**
   * Application routing
   */
  angular.module('thatsaboy')
    .config(routing);

  routing.$inject = ['$stateProvider', '$urlRouterProvider'];
  function routing($stateProvider, $urlRouterProvider) {

    /**
     * Default path
     */
    $urlRouterProvider.otherwise('/index');

    /**
     * Abstract state
     */
    $stateProvider
      .state('app', {
        url        : "/app",
        templateUrl: "/app/core/templates/app.html",
        abstract   : true
      });
    
    /**
     * Main page
     */
    $stateProvider
      .state('app.index', {
        url  : "^/index",
        views: {
          'content': {
            controller  : "indexController",
            controllerAs: "indexCtrl",
            templateUrl : "/app/modules/index/templates/index.html"
          }
        }
      });

    /**
     * Create new family page
     */
    $stateProvider
      .state('app.family_new', {
        url  : "^/new",
        views: {
          'content': {
            controller  : "familyNewController",
            controllerAs: "familyCtrl",
            templateUrl : "/app/modules/family/templates/family_new.html",
          }
        }
      });
    
    /**
     * Family page
     */
    $stateProvider
      .state('app.family', {
        url  : "^/family",
        views: {
          'content': {
            controller  : "familyController",
            controllerAs: "familyCtrl",
            templateUrl : "/app/modules/family/templates/family.html",
            resolve     : {
              family: function (familyRepository) {
                return familyRepository.get();
              }
            }
          }
        }
      });
  }
})();