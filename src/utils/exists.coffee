
# dependencies
fs = require 'fs'

# exists
exists = (file) ->
  fs.existsSync file

# export
module.exports = exists
