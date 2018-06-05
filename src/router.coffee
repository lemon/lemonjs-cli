
# dependencies
Path = require 'path'
compression = require 'compression'
express = require 'express'
fs = require 'fs'

# local dependencies
config = require Path.resolve __dirname, 'config'
compile = require Path.resolve __dirname, 'compile'

# create router
router = express.Router()

# browser-reload for dev
if config.env is 'dev'

  # dev dependencies
  sendevent = require 'sendevent'
  watch = require 'watch'

  # client-side reload script
  router.get '/reload.js', (req, res) ->
    fs.readFile "#{__dirname}/lib/reload.js", 'utf8', (err, js) ->
      return res.status(400).send {err} if err
      res.set 'Content-Type', 'text/javascript'
      res.send js

  # server-side server-sent event library
  sse = sendevent '/sse'
  router.use sse

  # watch for file changes
  for dir in [config._src, config._data]
    watch.watchTree dir, {
      ignoreDotFiles: true
      ignoreNotPermitted: true
      ignoreUnreadableDir: true
      interval: 0.1
      wait: 1
    }, (file, curr, prev) ->
      if typeof file is 'string'
        console.info 'File Changed: ', file.replace config._root, ''
        compile.handleFileChange file
        sse.broadcast {
          file: file
          reload: true
        }

# gzip
router.use compression()

# static resources
router.use express.static(config._static)

# built resources
router.use express.static(config._build)

# error handling
router.use (req, res, next) ->
  res.error = (status_code, err) ->
    [status_code, err] = [400, status_code] if not err

    # detailed dev response
    if config.env is 'dev'
      note = "make any code change and this page will refresh."
      err = {stack: err} if typeof err is 'string'
      re = new RegExp "(#{config._src})(/[^\)]+)", 'g'
      style = 'color:red;font-weight:bold;'
      res.set 'Content-Type', 'text/html'
      res.status status_code
      res.send """
        <h2>Lemon: An Error Has Occured</h2>
        <pre>
        #{('-' for i in [0...note.length]).join ''}
        #{err.stack.replace re, "$1<span style='#{style}'>$2</span>"}
        #{('-' for i in [0...note.length]).join ''}
        </pre>
        <pre>
        #{note}
        </pre>
        <script src='/reload.js'></script>
      """

    # generic prod response
    else
      res.send {error: 'An error has occurred'}
  next()

# load site
router.get ':pathname(*)', (req, res, next) ->
  filepath = "#{config._src}/index"
  html = compile filepath, {
    data: req.data
    hash: req._parsedUrl.hash or ''
    href: "#{config.origin}#{req._parsedUrl.href}"
    next: next
    pathname: req.params.pathname
    query: req.query or {}
    req: req
    res: res
    search: req._parsedUrl.search or ''
    url: "#{config.origin}#{req._parsedUrl.pathname}"
    onError: (err) ->
      res.error err
  }
  if html
    res.send html

# export
module.exports = router
