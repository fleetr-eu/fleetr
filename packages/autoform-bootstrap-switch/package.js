Package.describe({
  name: 'fleetr:autoform-bootstrap-switch',
  summary: 'Custom input type "bootstrap-switch" for AutoForm',
  version: '0.1.0',
  git: 'https://github.com/fleetr-eu/autoform-bootstrap-switch.git'
});

Package.onUse(function(api) {
  api.versionsFrom('1.0');

  //== Use
  // Client only
  api.use([
    // standard-app-packages
    'templating',

    // Additional packages
    'aldeed:autoform'
  ], 'client');

  //== Add files
  // Client only
  api.addFiles([
    'autoform-bootstrap-switch.html',
    'autoform-bootstrap-switch.js',
  ], 'client');
});

Package.onTest(function(api) {
  //== Use
  // Client only
  api.use([
    'tinytest',
    'ctjp:autoform-bootstrap-switch'
  ], 'client');

  //== Add files
  // Client only
  api.addFiles('tests/autoform-bootstrap-switch.js', 'client');
});
