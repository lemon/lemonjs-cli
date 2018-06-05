
# dependencies
CleanCSS = require 'clean-css'
Path = require 'path'
nib = require 'nib'
stylus = require 'stylus'

# local dependencies
config = require Path.resolve __dirname, '..', 'config'
read = require Path.resolve __dirname, '..', 'utils', 'read'

# compile stylus
compile = (file, options) ->
  dir = Path.dirname file
  style = stylus(read(file))
  style.set 'paths', [dir, config._modules]
  style.set 'include css', true
  style.define 'url', stylus.url()
  style.use nib()
  style.set 'compress', options.minify
  css = style.render()
  if options.minify
    css = new CleanCSS().minify(css).styles
  return css

# export
module.exports = compile
