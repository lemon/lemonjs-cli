
# css
require './App.css'

# component
module.exports = lemon.Component {

  # package assigns a namespace for our component
  package: 'site'

  # name assigns a name for our component in our namespace
  name: 'App'

  # id will add a dom id to our component
  id: 'app'

  # default data for our component (aka: state/properties/attributes)
  data: {
    time: null
  }

  # lifecycle hooks
  lifecycle: {

    # we will start a timer to update our local time each second
    created: ->
      @time = Date.now()
      @interval_id = setInterval ( =>
        @time = Date.now()
      ), 1000

    beforeDestroy: ->
      clearInterval @interval_id
  }

  # this is our template to render to the dom
  # by using the "_on" attribute, we can listen for real-time
  # changes to the time property
  template: (data) ->
    div _on: 'time', _template: (time) ->
      new Date(time).toLocaleTimeString()

}
