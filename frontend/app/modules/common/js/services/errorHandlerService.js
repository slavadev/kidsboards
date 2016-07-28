(function () {
  'use strict';

  angular.module('thatsaboy.common')
    .factory('errorHandlerService', errorHandlerService);


  errorHandlerService.$inject = [
    '$mdDialog',
    '$state',
    'localStorageService'
  ];

  function errorHandlerService($mdDialog, $state, localStorageService) {

    var handlersList = [
      wrongPassword,
      notUnique,
      blank,
      invalid,
      min6letters
    ];

    function capitalize(text) {
      return text.substring(0, 1).toUpperCase() + text.substring(1);
    }

    function wrongPassword(data) {
      if (data.email.indexOf('Wrong email or password') > -1) {
        return ' Wrong email or password.'
      }
      return '';
    }

    function notUnique(data) {
      var text = '';
      angular.forEach(data, function (attribute, name) {
        if (attribute.indexOf('is not unique') > -1) {
          text += ' ' + capitalize(name) + ' is already used.';
        }
      });
      return text;
    }

    function blank(data) {
      var text = '';
      angular.forEach(data, function (attribute, name) {
        if (attribute.indexOf("can't be blank") > -1) {
          text += ' ' + capitalize(name) + " can't be blank.";
        }
      });
      return text;
    }

    function invalid(data) {
      var text = '';
      angular.forEach(data, function (attribute, name) {
        if (attribute.indexOf('is invalid') > -1) {
          text += ' ' + capitalize(name) + ' is invalid.';
        }
      });
      return text;
    }

    function min6letters(data) {
      var text = '';
      angular.forEach(data, function (attribute, name) {
        if (attribute.indexOf('is too short (minimum is 6 characters)') > -1) {
          text += ' ' + capitalize(name) + ' is too short (minimum is 6 characters).';
        }
      });
      return text;
    }

    function handle422(data) {
      var text = '';

      angular.forEach(handlersList, function (handler) {
        text += handler(data)
      });

      $mdDialog.show(
        $mdDialog.alert()
          .parent(angular.element(document.body))
          .clickOutsideToClose(true)
          .title('Error')
          .textContent(text.trim())
          .ok('Ok')
      );
    }

    function handle401(data) {
      localStorageService.remove("token");
      $state.go('app.index');
    }

    function recoveryHandle401(data) {
      $mdDialog.show(
        $mdDialog.alert()
          .parent(angular.element(document.body))
          .clickOutsideToClose(true)
          .title('Error')
          .textContent('The link is broken or has already been used.')
          .ok('Ok')
      );
      $state.go('app.index');
    }

    function handle403(data) {
    }

    function handle500(data) {
    }

    function basicErrorHandler(response) {
      if (response.status == 401) {
        handle401(response.data);
      } else if (response.status == 403) {
        handle403(response.data);
      } else if (response.status == 422) {
        handle422(response.data);
      } else if (response.status == 500) {
        handle500(response.data);
      }
      reject();
    }

    function recoveryErrorHandler(response) {
      if (response.status == 401) {
        recoveryHandle401(response.data);
      } else if (response.status == 403) {
        handle403(response.data);
      } else if (response.status == 422) {
        handle422(response.data);
      } else if (response.status == 500) {
        handle500(response.data);
      }
      reject();
    }

    return {
      basicErrorHandler   : basicErrorHandler,
      recoveryErrorHandler: recoveryErrorHandler
    }
  }
})();