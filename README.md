# caffeinated-react-starter

A starter for how to elegantly use React and Coffeescript together.

## To install
You will need to first install the node.js javascript runtime from https://nodejs.org/

Then:

1. git clone git@github.com:ryanhinkel/caffeinated-react-starter.git
2. npm install
3. npm start
4. navigate to http://localhost:8080/webpack-dev-server/

## To create a component

First, require a create element function
``` coffeescript
{ div } = require('./elements')
```

Use it by calling the function. The first argument is an attributes object. The rest of the arguments will become children.
``` coffeescript
div { className: 'block' }, "Hello"
```

You can also pass an array as the second argument.
``` coffeescript
div { className: 'block' }, ["Hello", "Goodbye"]
```

You can pass elements as arguments. They will also become children. Remember, you need to call the `div` function to get an element.
``` coffeescript
div { className: 'block' },
  div {}, "Hello",
  div {}, "Goodbye"
```

At the top level, use react-dom to render the element into the dom
``` coffeescript
{ render } = require 'react-dom'
{ div } = require './elements'

ui = div {}, "Hello"
element = document.getElementById 'app'
render ui, element
```

