
# dependencies
CleanCSS = require 'clean-css'
Module = require 'module'
Path = require 'path'
coffee = require 'coffeescript'
fs = require 'fs'
lemoncup = require 'lemoncup'
uglify = require 'uglify-js'

# local dependencies
blacklist = require Path.resolve __dirname, 'utils', 'blacklist'
config = require Path.resolve __dirname, 'config'
exists = require Path.resolve __dirname, 'utils', 'exists'
read = require Path.resolve __dirname, 'utils', 'read'
readCSON = require Path.resolve __dirname, 'utils', 'readCSON'
serverCompFn = require Path.resolve __dirname, 'utils', 'server-comp-fn'
sha1 = require Path.resolve __dirname, 'utils', 'sha1'
stringify = require Path.resolve __dirname, 'utils', 'stringify'

# compilers
compilers = {
  css: require Path.resolve __dirname, 'compilers', 'css'
  js: require Path.resolve __dirname, 'compilers', 'javascript'
  stylus: require Path.resolve __dirname, 'compilers', 'stylus'
}

# setup global browser-like environment (lemon, site, page, window, document)
require Path.resolve __dirname, 'utils', 'setup'

# cache loaded files so we don't need to reprocess every request
_cache = {}

# override require to intercept dependency requests
_require = Module.prototype.require
Module.prototype.require = (filename) ->
  file = Module._resolveFilename filename, this
  ext = Path.extname file
  if file.match config._src
    return unless lemon.require file
    return _require.apply(this, arguments)
  for pkg in config.packages
    if file.match pkg
      return unless lemon.require file
  if ext in ['.css', '.styl']
    return unless lemon.require file
  return _require.apply(this, arguments)

# load lemon-browser lib
dist = Path.join __dirname, '..', 'node_modules', 'lemonjs-browser', 'dist'
_cache['lemon.js'] = read Path.join dist, "lemon.js"
_cache['lemon.min.js'] = read Path.join dist, "lemon.min.js"

# load lemoncup lib
dist = Path.join __dirname, '..', 'node_modules', 'lemoncup', 'dist'
_cache['lemoncup.js'] = read Path.join dist, "lemoncup.js"
_cache['lemoncup.min.js'] = read Path.join dist, "lemoncup.min.js"

# handle file change
handleFileChange = (file) ->

  # clear cache
  delete _cache[file]

  # is data file
  # make sure file still exists (it wasn't deleted)
  if file.indexOf(config._data) >= 0 and exists file
    ext = Path.extname file
    pathname = file.replace(config._data, '').replace(ext, '').replace('/index', '')
    pathname = '/' if pathname is ''
    if ext is '.cson'
      site.data[pathname] = readCSON file
    else if ext is '.md'
      site.markdown[pathname] = read file

# compile
compile = (filename, options) ->
  {onError} = options
  {href, pathname, search, hash, query, url} = options

  # clear template cache
  for k of require.cache
    if k.match config._src
      delete require.cache[k]
    for pkg in config.packages
      if k.match pkg
        delete require.cache[k]

  # set location details
  global.location = {
    href: href
    pathname: pathname
    search: search or ''
    hash: hash or ''
  }

  # allow custom data
  if options.data
    site.data[pathname] = options.data

  # set page details
  global.page = {
    data: site.data[pathname]
    href: href
    markdown: site.markdown[pathname]
    pathname: pathname
    query: query
    url: url
  }

  # cache css and js
  deps = {css: [], js: []}

  # gather css and js dependencies while compiling app
  lemon.require = (file) ->
    return false if file in deps.css
    return true if file in deps.js
    _options = {
      minify: config.env is 'prod'
    }
    ext = Path.extname file

    switch ext

      when '.css'
        _cache[file] ?= compilers.css file, _options
        deps.css.push file
        return false

      when '.js'
        _cache[file] ?= compilers.js file, _options
        deps.js.push file
        return true

      when '.styl'
        _cache[file] ?= compilers.stylus file, _options
        deps.css.push file
        return false

    return true

  # clear lemoncup data cache
  lemoncup.clear()

  # set of packages being used
  lemon.Packages = {
    lemon: true
  }

  # set of components to transfer to the client
  lemon.Specs = {}

  # custom server-side version of Component to render initial template
  # then prepare dom for client-side version
  lemon.Component = (spec) ->
    pkg = spec.package
    name = spec.name
    key = "#{pkg}.#{name}"

    # validate component has package, name, template
    if not name
      throw new Error "Component needs 'name': #{name}"
    if not pkg
      throw new Error "Component needs 'package': #{pkg}"
    if pkg in blacklist
      throw new Error "#{pkg} is a forbidden package name"

    # save component to load to browser
    # components are often re-used, so hash them and only store once
    # store them by key so they can be used in client-side rendering
    # check for collisions (key matches but hash doesn't)
    spec.hash = sha1 spec
    lemon.Packages[pkg] = true
    lemon.Specs[key] ?= spec

    if lemon.Specs[key].hash isnt spec.hash
      throw new Error "lemon Component name collision: #{key}"

    # render server-side dom and initial template
    # need to merge data because we run the template directly.
    # In the browser, these are merged in the Component constructor
    global[pkg] ?= {}
    global[pkg][name] = serverCompFn(spec)
    return global[pkg][name]

  # create lemon.Router
  lemon.Component {
    package: 'lemon'
    name: 'Router'

    data: {
      init: true
      prev: {}
      beforeRoute: (current, prev) ->
        return false if current?.pathname is prev?.pathname
        return true
      routed: ->
    }

    # setTimeout so that redirects can be done in a route
    # action. That way we're guaranteed to let the router
    # finish mounting before attempting a new route.
    methods: {
      onRoute: ->
        routes = @_data.routes or @_data
        match = lemon.checkRoutes routes
        prev = @prev
        @prev = match
        if @init
          @init = false
        else if match
          return if @beforeRoute?(match, prev) is false
          setTimeout ( =>
            @mount()
            @routed?(match)
          ), 0
    }

    routes: {
      '/*': 'onRoute'
    }

    # check routes need to happen in the template for server-side loading
    template: (data) ->
      routes = data.routes or data
      match = lemon.checkRoutes routes
      match?.action match
  }

  lemon.route = (url) ->
    lemoncup.script type: 'text/javascript', "document.location = '#{url}';"

  # render template
  try
    template = require filename
    html = lemoncup.render template, options.data
  catch err
    onError err
    return null

  inject = (ext, contents, name) ->
    return unless contents
    name ?= "#{sha1 contents}.#{ext}"
    file = Path.resolve config._bundle, name
    pathname = "/bundle/#{name}"
    if ext is 'js'
      val = "<script type='text/javascript' src='#{pathname}'></script>"
      html = html.replace "</body>", "\n#{val}</body>"
    if ext is 'css'
      val = "<link rel='stylesheet' type='text/css' href='#{pathname}'>"
      html = html.replace "</head>", "\n#{val}</head>"
    fs.writeFileSync file, contents, 'utf8'

  # inject js: dependencies, transfer, and lemon core
  js_app = "
    #{("if(!window['#{k}']){window['#{k}']={}};" for k of lemon.Packages).join ''}
    lemoncup._data = #{stringify lemoncup._data};
    lemon.Specs = #{stringify lemon.Specs};
    window.site = #{stringify site};
    window.page = #{stringify page};
    lemon.init();
  "
  if config.env is 'prod'
    js_deps = (_cache[dep] for dep in deps.js).join ''
    inject 'js', js_deps + _cache['lemoncup.min.js'] + _cache['lemon.min.js'] + js_app
  else
    inject 'js', _cache[dep] for dep in deps.js
    inject 'js', _cache['lemoncup.js'], 'lemoncup.js'
    inject 'js', _cache['lemon.js'], 'lemon.js'
    inject 'js', js_app, 'app.js'

  # inject css dependencies
  css_deps = (_cache[dep] for dep in deps.css).join ''
  if config.env is 'prod'
    css_deps = new CleanCSS().minify(css_deps).styles
  inject 'css', css_deps

  # inject reload script if on dev
  if config.env is 'dev'
    script = "<script src='/reload.js'></script>"
    html = html.replace "</body>", "#{script}\n</body>"

  return html

# exports
compile.cache = _cache
compile.handleFileChange = handleFileChange
module.exports = compile
