{ render } = require 'react-dom'
{ createElement } = require 'react'
{ div } = require '../lib/elements'
gears = require './gears_canvas'
copy = require '../assets/copy'

app = () ->
  div {},
    gears {}
    div {className: "copy", dangerouslySetInnerHTML: {__html: copy}},

render app(), document.getElementById 'app'
