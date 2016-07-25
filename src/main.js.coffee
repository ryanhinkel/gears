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

  ctx.beginPath()
  ctx.strokeStyle = "rgba(#{g.color.r}, #{g.color.g}, #{g.color.b}, 1)"
  ctx.lineWidth = 0.8
  for seg in g.pathObj
    result = []
    for coor in seg.coor
      Array.prototype.push.apply(result, coorTools.rotate(rotation/g.ratio, g.center, coor))

    ctx[canvasOps[seg.op]].apply(ctx, result)
  ctx.stroke()

drawGears = (ctx, gears, parameters) ->
  ctx.clearRect(0, 0, 1000, 1000)
  for gear, index in gears
    drawGear ctx, gear, parameters


module.exports = (ctx, gears) ->
  (parameters) ->
    drawGears(ctx, gears, parameters)
