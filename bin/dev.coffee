
# set environment to dev
global.LEMON_ENV = 'dev'

# dependencies
Path = require 'path'
express = require 'express'
mkdirp = require 'mkdirp'
rimraf = require 'rimraf'

# local dependencies
config = require Path.resolve __dirname, '..', 'src', 'config'
router = require Path.resolve __dirname, '..', 'src', 'router'
slashes = require Path.resolve __dirname, '..', 'src', 'utils', 'slashes'

dev = (argv) ->

  # clean and recreate build directory
  rimraf.sync config._build
  mkdirp.sync config._build
  mkdirp.sync config._bundle

  # create server
  app = express()

  # trim trailing slashes
  app.use slashes

  # route requests
  app.use router

  # start server
  app.listen config.port, ->
    console.info "listening at http://localhost:#{config.port}"

# export
module.exports = dev
