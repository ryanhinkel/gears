{ render } = require 'react-dom'
{ createElement } = require 'react'
{ div } = require './elements'
gears = require './gears'

# copy = require './copy'

app = div {},
  gears(0)
  #div {}, copy

refresh = (props) ->
  element = document.getElementById 'app'
  render app, element

refresh()
