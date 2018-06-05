
// dependencies
var Path = require('path');

// allow coffeescript
require('coffeescript/register');

// export
module.exports = {
  compile: require(Path.resolve('compile')),
  router: require(Path.resolve('router'))
}
