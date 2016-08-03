(function () {
  // creating container

  var containerId     = 'svg-icons-container';
  var container       = document.createElement('div');
  container.id        = containerId;
  container.innerHTML = '<!-- inject:svg --><!-- endinject -->';
  // hiding container
  container.style.width   = '0';
  container.style.height  = '0';
  container.style.display = 'none';

  // appending container to body tag
  document.body.appendChild(container);


})();