
# server-side component render function
serverCompFn = (spec) ->
  spec.template ?= ->
  fn = (data = {}, contents) ->
    data = Object.assign {}, lemon.copy(spec.data), data
    data.id = spec.id if spec.id
    data.class ?= ''
    data.class += " #{spec.class}" if spec.class
    attrs = {}
    for k, v of data
      if k in ['id', 'class']
        attrs[k] = v
      if k in ['style', 'data', 'on', 'bind'] or k[0] in ['$', '_']
        attrs[k] = v
        delete data[k]
    attrs['lemon-component'] = "#{spec.package}.#{spec.name}"
    attrs['lemon-contents'] = contents if contents
    attrs['lemon-data'] = data
    tag (spec.element or 'div'), attrs, ->
      spec.template data, contents
  fn.toString = -> "function(){#{spec.package}.#{spec.name}.apply(null, arguments)}"
  return fn

# export
module.exports = serverCompFn
