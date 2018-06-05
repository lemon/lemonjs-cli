
# dependencies
Path = require 'path'
uglify = require 'uglify-js'

# local dependencies
read = require Path.resolve __dirname, '..', 'utils', 'read'

# compile
compile = (file, options) ->
  js = read file
  if options.minify
    js = uglify.minify(js, {compress: {passes: 2}}).code
  return js

# exports
module.exports = compile
