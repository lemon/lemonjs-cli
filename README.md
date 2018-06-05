## lemonjs-cli

The CoffeeScript library for building user interfaces

<p>
  <a href="https://chat.lemonjs.org/"><img src="https://img.shields.io/badge/chat-on%20discord-7289da.svg" alt="Chat"></a>
  <a href="https://npmcharts.com/compare/lemonjs-cli?minimal=true"><img src="https://img.shields.io/npm/dm/lemonjs-cli.svg" alt="Downloads"></a>
  <a href="https://www.npmjs.com/package/lemonjs-cli"><img src="https://img.shields.io/npm/v/lemonjs-cli.svg" alt="Version"></a>
  <a href="https://www.npmjs.com/package/lemonjs-cli"><img src="https://img.shields.io/npm/l/lemonhs-clie.svg" alt="License"></a>
</p>
 
## 抛砖引玉

We launch this project to begin a conversation, not to give a mandate.  We have
a long way to go before this project reaches the maturity of React and Vue, but
we hope you are excited as we are to pursue this endeavor.  We encourage
everyone to come forward with their ideas and to contribute to this project.

## Introduction
Lemon is a radically fast way to build user interfaces. Just 9kb gets you
reactive, routable, stateful components and SEO friendly apps without a
line of javascript or html.

A basic lemon app can be built with zero local dependencies and a lightweight
cli which injects 8KB of javascript to run your application.

When you build Single Page Applications, you lose Search Engine
Optimization.  When you build server-side rendered dynamic websites,
you lose stateful, reactive, component-based User Interfaces. Lemon
gives you both. Lemon renders your application server-side, sending SEO
optimized html to the browser. Once in the browser, all necessary
reactive data listeners and event handlers are attached.

Components should be easy to manage. You should be allowed to choose
between static and dynamic data. You should not have to manage both
props and state. You should not have to manually bind every event
listener. You should not have to cleanup timeouts and child components.
Lemon makes component management flexible, simple, and intuitive.

## Installation
```
npm install -g lemonjs-cli
mkdir project ; cd project
lemon new
lemon dev
```

## Documentation
visit https://www.lemonjs.org

## Support
For questions and support please use the [community chat on discord](https://discord.gg/X3c6xu8).

## Ecosystem
| Project         | Description                    | Source     | Website     |
| --------------- | ------------------------------ | ---------- | ----------- |
| lemonjs-cli     | build with lemon               | [source](https://github.com/lemon/lemonjs-cli) | [website](https://www.lemonjs.org) |
| lemonjs-browser | lemon browser lib              | [source](https://github.com/lemon/lemonjs-browser) | |
| lemoncup        | lemon templating               | [source](https://github.com/lemon/lemoncup) | |
| lemonjs-i8c     | icons8 (cotton) library        | [source](https://github.com/lemon/lemonjs-i8c) | [website](https://i8c.lemonjs.org) |
| lemonjs-i8u     | icons8 (ultraviolet)  library  | [source](https://github.com/lemon/lemonjs-i8u) | [website](https://i8u.lemonjs.org) |
| lemonjs-lui     | lemon ui component library     | [source](https://github.com/lemon/lemonjs-lui) | [website](https://lui.lemonjs.org) |
| lemonjs-mui     | material ui component library  | [source](https://github.com/lemon/lemonjs-mui) | [website](https://mui.lemonjs.org) |
| lemonjs-ei      | evil icons component library   | [source](https://github.com/lemon/lemonjs-ei) | [website](https://ei.lemonjs.org) |
| lemonjs-wg      | webgradients component library | [source](https://github.com/lemon/lemonjs-wg) | [website](https://wg.lemonjs.org) |



## Inspiration
Inspired by the component-based ideology of [React.js](https://github.com/facebook/react), the simple API of [Vue.js](https://github.com/vuejs), and the beauty of [Coffeescript](https://coffeescript.org) and [Teacup](https://github.com/goodeggs/teacup).

Other projects made a great effort to combine coffeescript with React using CJSX: [coffee-react-transform](https://github.com/jsdf/coffee-react-transform), and [coffeescript](https://coffeescript.org/v2/#jsx), but React's structure and templating are painful.

[Teact](https://github.com/hurrymaplelad/teact#how-is-this-better-than-cjsx) did a great job combining teacup and React. Familiar control flow with branching and loops, no transpiling, and no extraneous close tags. That project fixes the templating issue, but still leaves us with a React-based app. We prefer the Vue.js approach to component management.

Vue.js + coffeescript is possible ([link1](https://laracasts.com/discuss/channels/vue/vue-and-coffeescript), [link2](https://github.com/DKhalil/coffeescript-vue-browserify-grunt)) and looks great, but it's still missing the beauty of the Teacup and Teact templating.

Other Coffeescript UI Libraries and template engines have been created, but none with minimal dependencies, an API as complete as Vue.js, server-side rendering, and thorough documentation: [quickui](https://github.com/JanMiksovsky/quickui), [coffeescript-ui](https://github.com/programmfabrik/coffeescript-ui), [kd](https://github.com/koding/kd), [singool](http://fahad19.github.io/singool/), [monocle](https://github.com/soyjavi/monocle), [reactionary](https://github.com/atom/reactionary/blob/master/src/dom-helpers.coffee), [thermos](https://github.com/sarenji/thermos), [coffee-html](https://github.com/mvc-works/coffee-html), [scene](https://github.com/amber/scene), [toffee](https://github.com/malgorithms/toffee).

## License

©2018 Shenzhen239 under the MIT license:

Permission is hereby granted, free of charge, to any person obtaining a copy of
this software and associated documentation files (the "Software"), to deal in
the Software without restriction, including without limitation the rights to
use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies
of the Software, and to permit persons to whom the Software is furnished to do
so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
