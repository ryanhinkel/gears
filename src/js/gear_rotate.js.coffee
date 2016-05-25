flatten = require 'lodash/flatten'
partial = require 'lodash/partial'
map = require 'lodash/map'

coorTools = require '../lib/coordinate_tools'

canvasOps =
  M: "moveTo"
  C: "bezierCurveTo"
  Z: "closePath"
  L: "lineTo"

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
  ctx.fillStyle = "rgba(255,255,255, .9)"
  ctx.lineWidth = 0.8
  drawSeg seg for seg in g.pathObj
  ctx.fill()
  ctx.stroke()
  # numbered gears, if you need them
  # ctx.fillText(g.id, g.center[0], g.center[1]);


drawGears = (ctx, gears, parameters) ->
  ctx.clearRect(0, 0, 1000, 1000)
  for gear, index in gears
    drawGear ctx, gear, parameters


module.exports = (ctx, gears) ->
  (parameters) ->
    drawGears(ctx, gears, parameters)
