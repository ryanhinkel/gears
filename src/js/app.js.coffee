{ render } = require 'react-dom'
{ createElement } = require 'react'
{ div } = require './elements'
gears = require './gears_canvas'
copy = require './copy'

app = () ->
  div {},
    gears {}
    div {}, copy

render app(), document.getElementById 'app'


# document.onmousemove = (event) ->
#   r = event.pageY/1000;
#   requestAnimationFrame(refresh)
