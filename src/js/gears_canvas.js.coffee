{ createClass, createFactory } = require 'react'
{ div, canvas } = require './elements'
map = require 'lodash/map'
flatten = require 'lodash/flatten'
partial = require 'lodash/partial'
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
    id: gear.id
  }

drawGear = (ctx, g, parameters) ->
  rotation = parameters[0]/3000
  opacity = Math.max((1-parameters[0]/1000), 0)
  rotate = partial coorTools.rotate, rotation/g.ratio, g.center
  drawSeg = (segment) ->
    # tranform coordinates
    coor = map seg.coor, rotate
    ctx[canvasOps[segment.op]].apply(ctx, flatten(coor))

  ctx.beginPath()
  ctx.strokeStyle = "rgba(#{g.color.r}, #{g.color.g}, #{g.color.b}, 1)"
  ctx.lineWidth = 0.8
  drawSeg seg for seg in g.pathObj
  ctx.stroke()
  # ctx.fillText(g.id, g.center[0], g.center[1]);

drawGears = (ctx, parameters) ->
  ctx.clearRect(0, 0, 1000, 1000)
  for gear, index in gears

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
