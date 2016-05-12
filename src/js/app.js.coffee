{ render } = require 'react-dom'
{ createElement } = require 'react'
{ div } = require './elements'
gears = require './gears'

# copy = require './copy'

FULL = Math.PI * 2

app = (rotation) ->
  div {},
    gears(rotation)
    #div {}, copy

r = 0

refresh = (props) ->
  # increment
  # r += .03
  # if r > FULL then r -= FULL
  element = document.getElementById 'app'
  render app(r), element
  # requestAnimationFrame(refresh)

document.onmousemove = (event) ->
  r = event.pageY/1000;
  requestAnimationFrame(refresh)
