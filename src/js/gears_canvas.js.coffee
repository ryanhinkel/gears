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

drawGear = (ctx, pathObj, color) ->
  ctx.beginPath()
  ctx.strokeStyle = "rgba(#{color.r}, #{color.g}, #{color.b}, 1)"
  ctx.fillStyle = 'rgba(255,255,255,0.8)'
  ctx.lineWidth = 0.8
  for segment in pathObj
    ctx[canvasOps[segment.op]].apply(ctx, flatten(segment.coor))
  ctx.stroke()
  ctx.fill()

drawGears = (rotation, ctx) ->
  ctx.clearRect(0, 0, 1000, 1000)
  for gear in gears
    drawGear ctx, rotateGear(gear, rotation), gear.color

gearCanvas = createClass
  setRef: (ref) ->
    ctx = ref.getContext("2d")
    ctx.scale(@pixelRatio, @pixelRatio)

    draw = () ->
      r = document.body.scrollTop/3000
      requestAnimationFrame () ->
      drawGears(r, ctx)

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
