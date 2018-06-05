###
# Middleware to redirect urls to not end in a slash
###
module.exports = (req, res, next) ->
  if req.path.substr(-1) is '/' and req.path.length > 1
    query = req.url.slice(req.path.length)
    res.redirect req.path.slice(0, -1) + query
  else
    next()
