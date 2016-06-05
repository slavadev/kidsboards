(function () {
  'use strict';

  angular.module('thatsaboy.common')
    .factory('errorHandlerService', errorHandlerService);


  errorHandlerService.$inject = [
    '$mdDialog'
  ];

  function errorHandlerService($mdDialog) {

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

    return {
      handle422: handle422
    }
  }
})();