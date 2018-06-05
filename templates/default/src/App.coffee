
# css
require './css/App.css'

# dependencies
require './components/Clock'

# component
module.exports = lemon.Component {
  package: 'site'
  name: 'App'
  id: 'app'

  template: (data) ->

    div '.wrapper', ->

      h1 -> page.data.title

      lemon.Router {
        '/': site.Clock
        '/*': ->
          div -> 'Page Not Found'
      }

      div '.docs', ->
        a href: 'https://www.lemonjs.org', ->
          'RTFD at lemonjs.org'

}

