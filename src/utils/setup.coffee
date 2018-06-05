
# dependencies
Path = require 'path'
lemoncup = require 'lemoncup'

# local dependencies
config = require Path.resolve __dirname, '..', 'config'
read = require Path.resolve __dirname, 'read'
readCSON = require Path.resolve __dirname, 'readCSON'
walk = require Path.resolve __dirname, 'walk'

# read config
{_data, hostname, name, origin, protocol} = config

# lemon
global.lemon = {}
require 'lemonjs-browser/src/util/copy'
require 'lemonjs-browser/src/util/check-route'
require 'lemonjs-browser/src/util/check-routes'

# lemon require
# will be overriden within each incoming request to gather
# dependencies for app compilation
lemon.require = -> return true

# page
global.page = {}

# site
global.site = {
  data: {}
  hostname: hostname
  markdown: {}
  name: name
  origin: origin
  protocol: protocol
}

# load site data
for file in walk _data
  continue if Path.basename(file)[0] is '.'
  ext = Path.extname file
  pathname = file.replace(_data, '').replace(ext, '').replace('/index', '')
  pathname = "/#{pathname}" if pathname[0] isnt '/'
  if ext is '.cson'
    site.data[pathname] = readCSON file
  else if ext is '.md'
    site.markdown[pathname] = read file

###
# browser (these shims help some dependencies load server-side)
###

# window
global.window = {}

# navigator
global.navigator = {
  userAgent: ''
}

# document
global.document = {
  documentElement: {
    classList: []
  }
  createElement: -> {
    style: {}
    getElementsByTagName: -> []
  }
}

# location
global.location = {}
