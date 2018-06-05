
# dependencies
Path = require 'path'
crypto = require 'crypto'

# local dependencies
stringify = require Path.resolve __dirname, 'stringify'

# cache previous results
_cache = {}

# compute sha1 hash
sha1 = (data) ->
  data = stringify data
  return _cache[data] if _cache[data]?
  result = crypto.createHash('sha1').update(data).digest 'hex'
  _cache[data] = result
  return result

# export
module.exports = sha1
