for key, spec of lemon.Specs
  [pkg, name] = key.split '.'
  do (key, pkg, name, spec) ->
    window[pkg][name] = (data = {}, contents) ->
      attrs = {}
      for k, v of data
        if k in ['id', 'class']
          attrs[k] = v
        if k in ['style', 'data', 'on', 'bind'] or k[0] in ['$', '_']
          attrs[k] = v
          delete data[k]
      attrs['lemon-component'] = "\#{pkg}.\#{name}"
      attrs['lemon-contents'] = contents if contents
      attrs['lemon-data'] = data
      tag (spec.element or 'div'), attrs
