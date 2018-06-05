
# set env
global.LEMON_ENV = 'dev'

# dependencies
Path = require 'path'
compression = require 'compression'
express = require 'express'
fs = require 'fs'

# local dependencies
config = require Path.resolve __dirname, '..', 'src', 'config'
slashes = require Path.resolve __dirname, '..', 'src', 'utils', 'slashes'

run = (argv) ->

  # create server
  app = express()

  # trim trailing slashes
  app.use slashes

  # gzip
  app.use compression()

  # add forward slash internally to urls so express static
  # finds our index.html files
  app.use (req, res, next) ->
    return next() if req.path.match "\\."
    req.url = '/index' if req.url is '/'
    req.url += '.html'
    next()

  # static files
  app.use express.static(config._build, {
    redirect: false
  })

  # send 404s to 404 page
  app.use '*', (req, res, next) ->
    return next() if req.path.match "\\."
    filename = Path.resolve config._build, '404.html'
    html = fs.readFileSync filename, 'utf8'
    res.send html

  # start server
  app.listen config.port, ->
    console.info "http://localhost:#{config.port}"

# export
module.exports = run
