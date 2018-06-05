
# dependencies
Path = require 'path'
URL = require('url').URL
fs = require 'fs'
mkdirp = require 'mkdirp'

# local dependencies
exists = require Path.resolve __dirname, 'utils', 'exists'
fail = require Path.resolve __dirname, 'utils', 'fail'
read = require Path.resolve __dirname, 'utils', 'read'
readCSON = require Path.resolve __dirname, 'utils', 'readCSON'

# make sure lemon.cson config exists
if not exists 'lemon.cson'
  fail "
    unable to find lemon.cson.
    lemon must be run from the root of your project
  "

# parse lemon.cson config
config = readCSON 'lemon.cson'
if not config
  fail "#{err}\nfailed to parse lemon.cson"

# validate required fields in config
if not config.name
  fail "invalid config: requires 'name'"

# set defaults
config.dev ?= {}
config.dev.hostname ?= 'localhost'
config.dev.port ?= 3000
config.dev.protocol ?= 'http'
config.name ?= 'Site Name'
config.packages ?= []
config.prod ?= {}
config.prod.hostname ?= null
config.prod.port ?= ''
config.prod.protocol ?= 'http'

# computed fields
{dev, prod} = config
dev.origin = new URL("#{dev.protocol}://#{dev.hostname}:#{dev.port}").origin
prod.origin = new URL("#{prod.protocol}://#{prod.hostname}:#{prod.port}").origin

# copy config.dev or config.prod to top-level config based on environment
env = global.LEMON_ENV or 'dev'
config.env = env
config.hostname = config[env].hostname
config.origin = config[env].origin
config.port = config[env].port
config.prototol = config[env].protocol

# setup directories
config._build = Path.resolve 'build'
config._bundle = Path.resolve 'build', 'bundle'
config._data = Path.resolve 'data'
config._modules = Path.resolve 'node_modules'
config._root = Path.resolve '.'
config._src = Path.resolve 'src'
config._static = Path.resolve 'src', 'static'

# create standard directories
mkdirp.sync config._build
mkdirp.sync config._bundle
mkdirp.sync config._data
mkdirp.sync config._src
mkdirp.sync config._static

# export
module.exports = config
