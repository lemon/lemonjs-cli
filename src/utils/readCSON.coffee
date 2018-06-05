
# dependencies
fs = require 'fs'
CSON = require 'cson-parser'

# readCSON
readCSON = (file) ->
  try
    result = CSON.parse fs.readFileSync(file, 'utf8')
  catch err
    console.info '---------'
    console.warn "Error parsing file: #{file}"
    if err.message
      console.warn "Error message: \"#{err.message}\""
    if err.location
      console.warn "Error location: #{JSON.stringify err.location, null, 2}"
    console.info '---------'
    return null
  return result

# export
module.exports = readCSON
