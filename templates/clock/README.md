## Lemon Tutorial: Clock App

### [Installation](/en/clock-tutorial?q=installation)

```bash
# install lemon-cli globally with npm
> npm install -g lemonjs-cli
```

---

### [Create a Project](/en/clock-tutorial?q=create)

```bash
# create a directory for your new project
> mkdir -p ~/lemon-clock-tutorial
> cd ~/lemon-clock-tutorial

# create your new project from an existing lemon template
> lemon new clock
```

---

### [Project Structure](/en/clock-tutorial?q=structure)

```bash
# quick glance at the project structure
> find .
.
./lemon.cson          # contains your lemon config file
./README.md           # project README
./src                 # src directory
./src/App.coffee      # your app
./src/App.css         # styling (for big projects, create a "css" directory)
./src/index.coffee    # your index.html
```

---

## [Project Configuration](/en/clock-tutorial?q=config)
### (lemon.cson)

```coffeescript
{
  name: "Lemon clock-tutorial"                # a name for your app
  dev: {
    port: 3000                                # local development port
  }
  prod: {
    hostname: 'clock-tutorial.lemonjs.org'    # where you app will be deployed
  }
}
```

'origin' is the url your site will eventually be located at. This property is
available anywhere in your application as site.origin. 'name' is the name of
your project. 'dev.prot' is the port that your local development server will
use.

[Learn More About CSON](https://github.com/bevry/cson)

---

# [Index.html Entrypoint](/en/clock-tutorial?q=index)
### (src/index.coffee)

```coffeescript
# dependencies
require './App'               # load your App component

# page template
module.exports = ->           # export your template
  doctype 5                   # use html5 doctype
  html ->
    head ->
      title 'Lemon clock-tutorial'  # browser title
    body ->
      site.App()              # load your App into body
```

Notice how we access our App with "site.App". Most, if not all,
components should be namespaced this way. In App.coffee, you'll
see how we define the namespace.

This template probably reminds you of html. This is coffeescript templating. It
looks beautiful and it's incredibly easy and flexible to work with. You may
have noticed what we're actually doing is calling functions with the names
'doctype', 'html', 'head', 'title', and 'site.App'. We're passing in an object
(the element attributes) and a function (the inner content of the element) to
the function. This gets compiled to javascript that runs both on the server and
in the browser to render html. site.App() is loading your first lemon Component.
Let's go see how it works.

Coffeescript Templating has a long history:
[Coffeekup](https://github.com/mauricemach/coffeekup),
[Coffeecup](https://github.com/gradus/coffeecup),
[Teacup](https://github.com/goodeggs/teacup).

Lemon currently uses a customized version of teacup.

---

# [Your Application](/en/clock-tutorial?q=app)
### (src/App.coffee)

```coffeescript
# styles
require './css/App.css'

# component
module.exports = lemon.Component {

  # 'package' assigns a namespace for our component
  package: 'site'

  # 'name' assigns a name for our component in our namespace
  name: 'App'

  # 'id' will add a dom id to our component
  id: 'app'

  # default data for our component (aka: state/properties/attributes)
  data: {
    time: null
  }

  # lifecycle hooks
  lifecycle: {

    # we will listen for mounting to complete
    created: ->

      # we will start a timer to update our local time each second
      @time = Date.now()
      @interval_id = setInterval ( =>
        @time = Date.now()
      ), 1000

    beforeDestroy: ->
      clearInterval @interval_id
  }

  # this is our template to draw to the dom
  # by using the "_on" attribute, we can listen for real-time
  # changes to the time property
  template: (data) ->
  div _on: 'time', _template: (time) ->
    new Date(time).toLocaleTimeString()

}
```

---

# [Styling](/en/clock-tutorial?q=styling)
### (src/App.css)

```css
#app {
  align-items: center;
  display: flex;
  font-family: monospace;
  font-size: 60px;
  height: 100vh;
  justify-content: center;
}
```

Here we loaded a style file for our project. Currently Stylus is
also supported, LESS and SASS support will come as soon as someone
requests them.

---

# [Run the Development Server](/en/clock-tutorial?q=dev)

```bash
> cd ~/dev/lemon-clock-tutorial
> lemon dev
listening at http://localhost:3000
```

---

# [Open your browser](/en/clock-tutorial?q=test)
### [http://localhost:3000](http://localhost:3000)

It should look something like this

<div lemon-component="site.Clock"></div>

---

# Next Steps

## Do the advanced tutorial (hackernews)

This was a good start, but there's a lot more you can do with
lemon. For a more advanced tutorial, go over to the
[hackernews](/en/hackernews) tutorial.

## Have questions?

Visit our [How To](/en/how-to) for code samples of common questions.
