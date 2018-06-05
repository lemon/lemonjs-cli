###
# Customize stringify based on environment
###

# dependencies
Path = require 'path'

# local dependencies
config = require Path.resolve __dirname, '..', 'config'
stringify = require Path.resolve __dirname, '..', 'lib', 'json-stringify-extended'

# stringify
_stringify = (data) ->
  opt = {}
  if config.env is 'prod'
    opt = {compress: true, endline: '', spacing: '', valueQuote: "'"}
  return stringify data, opt

# export
module.exports = _stringify
