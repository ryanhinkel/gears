{ createClass } = require 'react'
{ svg, path, circle } = require './svg_elements'
{ div } = require './elements'
map = require 'lodash/map'
t = require './coordinate_tools'
paths = require './gear_paths'

gears = map paths, (gear) ->
  jpn: t.toAbsolute(t.toJPN(gear.d))
  ratio: gear.ratio

style =
  fill: '#fff'
  fillOpacity: 0.8
  stroke: '#333'

rotateGear = (gear, rotation) ->
  center = t.findCenter(gear.jpn)
  rotated = t.rotateJPN(gear.jpn, center, rotation/gear.ratio)
  t.toPath(rotated)

gearsSVG = (rotation) ->
  gearPath = rotateGear(gears[0], rotation)

  gearPaths = map gears, (gear) ->
    rotateGear(gear, rotation)

  div {className: 'gears'},
    svg { version: "1.1", xmlns: "http://www.w3.org/2000/svg", width: "100%", height: "100%", x: "0px", y: "0px", viewBox: "0 0 1113 1131" },
      map gearPaths, (p, index) ->
        path
          key: index
          d: p
          style: style
      # path
      #   id:"gear0"
      #   d: gearPath
      #   style: style

      # path
      #   id:"gear1"
      #   d: gear1
      #   style: style
      # path
      #   id:"gear2"
      #   d: gear2
      #   style: style
      # path
      #   id:"gear3"
      #   d: gear3
      #   style: style
      # path
      #   id:"gear4"
      #   d: gear4
      #   style: style
      # path
      #   id:"gear5"
      #   d: gear5
      #   style: style
      # path
      #   id:"gear6"
      #   d: gear6
      #   style: style
      # path
      #   id:"gear7"
      #   d: gear7
      #   style: style
      # path
      #   id:"gear8"
      #   d: gear8
      #   style: style
      # path
      #   id:"gear9"
      #   d: gear9
      #   style: style
      # path
      #   id:"gear10"
      #   d: gear10
      #   style: style
      # path
      #   id:"gear11"
      #   d: gear11
      #   style: style
      # path
      #   id:"gear12"
      #   d: gear12
      #   style: style

module.exports = gearsSVG
