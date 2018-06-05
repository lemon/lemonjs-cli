
# dependencies
fs = require 'fs'

# read
read = (file) ->
  fs.readFileSync file, 'utf8'

# export
module.exports = read
