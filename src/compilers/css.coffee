
# dependencies
CleanCSS = require 'clean-css'
Path = require 'path'

# local dependencies
read = require Path.resolve __dirname, '..', 'utils', 'read'

# compile css
compile = (file, options) ->
  css = read file
  if options.minify
    css = new CleanCSS().minify(css).styles
  return css

# export
module.exports = compile
