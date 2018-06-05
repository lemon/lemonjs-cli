
# set environment to prod
global.LEMON_ENV = 'prod'

# dependencies
Path = require 'path'
fs = require 'fs'
mkdirp = require 'mkdirp'
rimraf = require 'rimraf'

# local dependencies
compile = require Path.resolve __dirname, '..', 'src', 'compile'
config = require Path.resolve __dirname, '..', 'src', 'config'
exists = require Path.resolve __dirname, '..', 'src', 'utils', 'exists'
fail = require Path.resolve __dirname, '..', 'src', 'utils', 'fail'
read = require Path.resolve __dirname, '..', 'src', 'utils', 'read'
readCSON = require Path.resolve __dirname, '..', 'src', 'utils', 'readCSON'
walk = require Path.resolve __dirname, '..', 'src', 'utils', 'walk'
write = require Path.resolve __dirname, '..', 'src', 'utils', 'write'

build = (argv) ->

  # clean and recreate build directory
  rimraf.sync config._build
  mkdirp.sync config._build
  mkdirp.sync config._bundle

  # make sure there is an index.cson
  if not exists "#{config._data}/index.cson"
    write "#{config._data}/index.cson", "{}"

  # notice
  console.info "STATUS: starting build"

  # walk data directory to find paths to build
  set = new Set()
  for file in walk config._data
    continue if Path.basename(file)[0] is '.'
    ext = Path.extname file
    continue if ext is '.cson' and readCSON(file)?._build is false
    path = file.replace "#{config._data}", ''
    path = path.replace ext, ''
    path = path.replace '/index', ''
    path = "/#{path}" if path[0] isnt '/'
    set.add path
  paths = Array.from(set)

  # compile each path
  for path in paths
    html = compile "#{config._src}/index", {
      pathname: path
      hash: ''
      href: "#{config.origin}#{path}"
      onError: (err) ->
        console.error err
        fail "STATUS: build failed"
      pathname: path
      query: {}
      search: ''
      url: "#{config.origin}#{path}"
    }
    path = '/index' if path is '/'
    dst = "#{config._build}#{path}.html"
    mkdirp.sync Path.dirname dst
    write dst, html
    console.info "HTML: #{path}.html"

  # compile data files to json
  for file in walk config._data
    ext = Path.extname file
    path = file.replace "#{config._data}/", ''
    if ext is '.cson'
      path = path.replace '.cson', '.json'
      contents = JSON.stringify readCSON file
    else
      contents = read file
    dst = "#{config._build}/#{path}"
    mkdirp.sync Path.dirname dst
    fs.writeFileSync dst, contents
    console.info "DATA: /#{path}"

  # copy static files
  for file in walk config._static
    path = file.replace "#{config._static}/", ''
    contents = fs.readFileSync file
    dst = "#{config._build}/#{path}"
    mkdirp.sync Path.dirname dst
    fs.writeFileSync dst, contents
    console.info "STATIC: /#{path}"

  # done
  console.info "STATUS: build complete"
  console.info "type `lemon run` to test your build"
  process.exit()

# export
module.exports = build
