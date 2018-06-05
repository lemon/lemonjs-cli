
# dependencies
fs = require 'fs'

# write
write = (file, content) ->
  fs.writeFileSync file, content, 'utf8'

# export
module.exports = write
