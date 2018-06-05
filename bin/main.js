
// dependencies
var path = require('path');

// allow coffeescript
require('coffeescript/register');

// load main cli handler
require(path.resolve(__dirname, 'main.coffee'));
