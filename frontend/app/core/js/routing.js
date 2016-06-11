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
     * Request recovery page
     */
    $stateProvider
      .state('app.request', {
        url  : "^/request",
        views: {
          'content': {
            controller  : "requestRecoveryController",
            controllerAs: "recoveryCtrl",
            templateUrl : "/app/modules/index/templates/request-recovery.html"
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

    /**
     * Create new adult page
     */
    $stateProvider
      .state('app.adult_new', {
        url  : "^/adult/new",
        views: {
          'content': {
            controller  : "adultNewController",
            controllerAs: "adultCtrl",
            templateUrl : "/app/modules/adults/templates/adult_new.html"
          }
        }
      });

    /**
     * Adult page
     */
    $stateProvider
      .state('app.adult', {
        url  : "^/adult/:id",
        views: {
          'content': {
            controller  : "adultController",
            controllerAs: "adultCtrl",
            templateUrl : "/app/modules/adults/templates/adult.html",
            resolve     : {
              adult: function (familyRepository, $stateParams) {
                return familyRepository.get().then(function(family){
                  return family.adults.filter(function(adult) {
                    return adult.id.toString() === $stateParams.id;
                  })[0]
                });
              }
            }
          }
        }
      });

    /**
     * Create new child page
     */
    $stateProvider
      .state('app.child_new', {
        url  : "^/child/new",
        views: {
          'content': {
            controller  : "childNewController",
            controllerAs: "childCtrl",
            templateUrl : "/app/modules/children/templates/child_new.html"
          }
        }
      });

    /**
     * Child page
     */
    $stateProvider
      .state('app.child', {
        url  : "^/child/:id",
        views: {
          'content': {
            controller  : "childController",
            controllerAs: "childCtrl",
            templateUrl : "/app/modules/children/templates/child.html",
            resolve     : {
              child: function (familyRepository, $stateParams) {
                return familyRepository.get().then(function(family){
                  return family.children.filter(function(child) {
                    return child.id.toString() === $stateParams.id;
                  })[0]
                });
              },
              goals: function (childRepository, $stateParams) {
                return childRepository.getGoals($stateParams.id);
              }
            }
          }
        }
      });

    /**
     * Create new goal page
     */
    $stateProvider
      .state('app.goal_new', {
        url  : "^/child/:id/goal/new",
        views: {
          'content': {
            controller  : "goalNewController",
            controllerAs: "goalCtrl",
            templateUrl : "/app/modules/goals/templates/goal_new.html"
          }
        }
      });

    /**
     * Goal page
     */
    $stateProvider
      .state('app.goal', {
        url  : "^/child/:child_id/goal/:id",
        views: {
          'content': {
            controller  : "goalController",
            controllerAs: "goalCtrl",
            templateUrl : "/app/modules/goals/templates/goal.html",
            resolve     : {
              goal: function (goalRepository, $stateParams) {
                return goalRepository.get($stateParams.id);
              },
              adults: function (familyRepository) {
                return familyRepository.get().then(function(family){
                  return family.adults;
                });
              }
            }
          }
        }
      });
  }
})();