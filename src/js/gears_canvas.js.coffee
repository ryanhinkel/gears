{ createClass, createFactory } = require 'react'
{ div, canvas } = require './elements'
map = require 'lodash/map'
flatten = require 'lodash/flatten'
t = require './coordinate_tools'
paths = require './gear_paths'

canvasOps =
  M: "moveTo"
  C: "bezierCurveTo"
  Z: "closePath"
  L: "lineTo"

gears = map paths, (gear) ->
  jpn: t.toAbsolute(t.toJPN(gear.d))
  ratio: gear.ratio

rotateGear = (gear, rotation) ->
  center = t.findCenter(gear.jpn)
  t.rotateJPN(gear.jpn, center, rotation/gear.ratio)

drawGear = (ctx, jpn) ->
  ctx.beginPath()
  ctx.strokeStyle = 'black'
  for segment in jpn
    ctx[canvasOps[segment.op]].apply(ctx, flatten(segment.coor))
  ctx.stroke()

drawGears = (rotation, ctx) ->
  ctx.clearRect(0, 0, 1000, 1000)
  for gear in gears
    drawGear ctx, rotateGear(gear, rotation)

gearCanvas = createClass
  setRef: (ref) ->
    ctx = ref.getContext("2d")

    document.onmousemove = (event) ->
      r = event.pageY/1000;
      requestAnimationFrame () ->
        drawGears(r, ctx)


  render: () ->
    canvas
      width: 1000
      height: 1000
      ref: this.setRef

module.exports = createFactory gearCanvas
