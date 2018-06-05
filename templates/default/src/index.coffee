
# dependencies
require './App'

# page template
module.exports = ->
  doctype 5
  html lang: 'en', ->
    head ->
      title 'Lemon Default App'
    body ->
      site.App()
