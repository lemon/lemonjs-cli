
# dependencies
fs = require 'fs'

# readJSON
readJSON = (file) ->
  try
    result = JSON.parse fs.readFileSync(file, 'utf8')
  catch err
    console.info '---------'
    console.warn "Error parsing file: #{file}"
    if err.message
      console.warn "Error message: \"#{err.message}\""
    if err.location
      console.warn "Error: #{err}"
    console.info '---------'
    return null
  return result

# export
module.exports = readJSON
