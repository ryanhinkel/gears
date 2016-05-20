{ createClass, createFactory } = require 'react'
{ div, canvas } = require './elements'
map = require 'lodash/map'
flatten = require 'lodash/flatten'
coorTools = require './coordinate_tools'
pathTools = require './path_tools'
paths = require './gear_paths'

canvasOps =
  M: "moveTo"
  C: "bezierCurveTo"
  Z: "closePath"
  L: "lineTo"

canvasWidth = 1000
canvasHeight = 1000

gears = map paths, (gear) ->
  pathObj = pathTools.convertFromPath(gear.d)
  {
    pathObj: pathObj
    ratio: gear.ratio
    center: pathTools.findCenter(pathObj)
    color: gear.color
  }

rotateGear = (gear, rotation) ->
  pathTools.rotatePathObject(gear.pathObj, gear.center, rotation/gear.ratio)

drawGear = (ctx, g, parameters) ->
  rotation = parameters[0]/3000

  ctx.beginPath()
  ctx.strokeStyle = "rgba(#{g.color.r}, #{g.color.g}, #{g.color.b}, 1)"
  ctx.lineWidth = 0.8

  drawSeg = (segment) ->
    ctx[canvasOps[segment.op]].apply(ctx, flatten(segment.coor))

  rg = rotateGear(g, rotation)
  drawSeg seg for seg in rg

  ctx.stroke()

drawGears = (ctx, parameters) ->
  ctx.clearRect(0, 0, 1000, 1000)
  for gear in gears
    drawGear ctx, gear, parameters

gearCanvas = createClass
  setRef: (ref) ->
    ctx = ref.getContext("2d")
    ctx.scale(@pixelRatio, @pixelRatio)

    draw = () ->
      parameters = [document.body.scrollTop]
      requestAnimationFrame () ->
        drawGears(ctx, parameters)

    window.onscroll = draw
    draw()

  render: () ->
    @pixelRatio = window.devicePixelRatio
    canvasWidth *= window.devicePixelRatio;
    canvasHeight *= window.devicePixelRatio;

    canvas
      className: 'gears'
      width: canvasWidth
      height: canvasHeight
      ref: this.setRef

module.exports = createFactory gearCanvas
