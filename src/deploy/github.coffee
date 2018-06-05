
# dependencies
Path = require 'path'
fs = require 'fs'
mkdirp = require 'mkdirp'
rimraf = require 'rimraf'

# local dependencies
config = require Path.resolve __dirname, '..', 'config'

# setup: nothing to do
setup = (next) ->
  next()

# clean production files: nothing to do
clean = (files, next) ->
  next()

# deploy entire build directory
deploy = (files, next) ->
  _docs = Path.resolve 'docs'
  rimraf.sync _docs

  # write CNAME file
  console.info "WRITE CNAME FILE"
  mkdirp.sync _docs
  fs.writeFileSync Path.resolve(_docs, 'CNAME'), config.prod.hostname, 'utf8'

  # copy files over
  for file in files
    console.info "COPY TO DOCS: #{file.dst}"
    dst = "#{_docs}#{file.dst}"
    contents = fs.readFileSync file.src
    mkdirp.sync Path.dirname dst
    fs.writeFileSync dst, contents
  next()

# exports
module.exports = {
  clean: clean
  deploy: deploy
  setup: setup
}
