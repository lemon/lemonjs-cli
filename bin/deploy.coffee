
###
# Wrapper for deploying lemon apps
###

# set environment to prod
global.LEMON_ENV = 'prod'

# dependencies
Path = require 'path'
fs = require 'fs'
mkdirp = require 'mkdirp'
rimraf = require 'rimraf'

# local dependencies
config = require Path.resolve __dirname, '..', 'src', 'config'
fail = require Path.resolve __dirname, '..', 'src', 'utils', 'fail'
read = require Path.resolve __dirname, '..', 'src', 'utils', 'read'
series = require Path.resolve __dirname, '..', 'src', 'lib', 'series'
walk = require Path.resolve __dirname, '..', 'src', 'utils', 'walk'

deploy = (argv) ->

  # notice
  console.info "STATUS: starting deploy"

  # deployment services
  services = ['gcs', 'github', 's3']

  # check for deploy config
  if not config.deploy
    fail "you must define 'deploy' in your lemon.cson"

  # validate required fields in config
  if not config.prod?.hostname
    fail "you must define 'prod.hostname' before deploying"

  # check for deploy.service
  if config.deploy.service not in services
    fail "invalid 'deploy.service'. must be one of [#{services.join ','}]"

  # load service
  service_name = config.deploy.service
  service = require Path.resolve __dirname, '..', 'src', 'deploy', service_name
  service.setup (err) ->
    return fail err if err

    # gather sources
    sources = walk config._build
    files = ({
      src: source
      dst: ((source) ->
        source = source.replace(config._build, '')
        return source
      )(source)
      dst_no_html: ((source) ->
        source = source.replace(config._build, '')
        source = source.replace(/\.html$/, '') if source isnt '/index.html'
        return source
      )(source)
    } for source in sources)

    # deploy to production
    service.deploy files, (err) ->
      return fail err if err
      console.info 'STATUS: deploy complete'

      # optional clean up old files
      if argv.clean
        console.info 'STATUS: cleaning production'
        service.clean files, (err) ->
          return fail err if err
          console.info 'STATUS: cleaning complete'

# exports
module.exports = deploy
