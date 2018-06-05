
# dependencies
Path = require 'path'

# local dependencies
config = require Path.resolve __dirname, '..', 'config'
eachLimit = require Path.resolve __dirname, '..', 'lib', 'each-limit'
readJSON = require Path.resolve __dirname, '..', 'utils', 'readJSON'
series = require Path.resolve __dirname, '..', 'lib', 'series'

# state
bucket = null
storage = null

# setup: check authenticate, setup bucket
setup = (next) ->

  # check for dependencies
  try
    Storage = require "#{config._modules}/@google-cloud/storage"
  catch err
    return next "`npm install -g @google-cloud/storage` to use gcs deploy"

  # check for required config
  for field in ['project', 'bucket', 'credentials']
    if not config.deploy[field]
      return next "deploy.#{field} must be defined to deploy to gcs"

  # check for valid authentication credentials
  creds = readJSON config.deploy.credentials
  if not creds
    return next "unable to read credentials:\n#{err}"
  storage = new Storage {
    projectId: config.deploy.project
    credentials: creds
  }

  # setup bucket
  bucket = storage.bucket config.deploy.bucket
  series [

    # create bucket if needed
    (next) ->
      bucket.exists (err, exists) ->
        return next err if err
        return next() if exists

        # create bucket if it didn't exist
        bucket.create next

    # set bucket metadata
    (next) ->
      bucket.setMetadata {
        website: {
          mainPageSuffix: 'index.html'
          notFoundPage: 'index.html'
        }
      }, next

    # make the bucket public
    (next) ->
      bucket.makePublic {}, next

  ], next

# wipe files no longer needed from production
clean = (files, next) ->
  paths = (file.dst_no_html for file in files)
  bucket.getFiles (err, items) ->
    return next err if err
    items = items.filter (item) -> "/#{item.name}" not in paths
    eachLimit items, 5, ((item, next) ->
      console.info "DELETE: /#{item.name}"
      item.delete next
    ), next

# deploy entire build directory
deploy = (files, next) ->
  eachLimit files, 5, ((file, next) ->
    console.info "UPLOAD: #{file.dst_no_html}"
    bucket.upload file.src, {
      destination: file.dst_no_html
      public: true
    }, next
  ), next

# exports
module.exports = {
  clean: clean
  deploy: deploy
  setup: setup
}
