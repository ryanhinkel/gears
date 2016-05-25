{ render } = require 'react-dom'
{ createElement } = require 'react'
{ div } = require '../lib/elements'

copy = require './assets/copy'
gears = require './gears_component'

app = () ->
  div {},
    gears {}
    div {className: "copy", dangerouslySetInnerHTML: {__html: copy}},

render app(), document.getElementById 'app'
