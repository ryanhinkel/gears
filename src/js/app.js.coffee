{ render } = require 'react-dom'
{ div } = require './elements'

refresh = (props) ->
  ui = div({}, props.message)
  element = document.getElementById 'app'
  render ui, element

refresh({ message: "Hello" })
