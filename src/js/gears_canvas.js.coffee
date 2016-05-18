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

canvasWidth = 1000
canvasHeight = 1000

gears = map paths, (gear) ->
  jpn: t.toAbsolute(t.toJPN(gear.d))
  ratio: gear.ratio

rotateGear = (gear, rotation) ->
  center = t.findCenter(gear.jpn)
  t.rotateJPN(gear.jpn, center, rotation/gear.ratio)

drawGear = (ctx, jpn) ->
  ctx.beginPath()
  ctx.strokeStyle = 'black'
  # ctx.fillStyle = 'rgba(255,255,255,0.5)'
  gradient = ctx.createRadialGradient(500,500,1000,500,500,0)
  gradient.addColorStop(0,"rgba(255,0,0,0.5")
  gradient.addColorStop(1,"rgba(100,0,0,0.5")
  ctx.fillStyle = gradient
  ctx.lineWidth = 0.8
  for segment in jpn
    ctx[canvasOps[segment.op]].apply(ctx, flatten(segment.coor))
  ctx.stroke()
  ctx.fill()

drawGears = (rotation, ctx) ->
  ctx.clearRect(0, 0, 1000, 1000)
  for gear in gears
    drawGear ctx, rotateGear(gear, rotation)

gearCanvas = createClass
  setRef: (ref) ->
    ctx = ref.getContext("2d")
    ctx.scale(@pixelRatio, @pixelRatio)

    window.onscroll = (event) ->
      r = document.body.scrollTop/1000
      requestAnimationFrame () ->
        drawGears(r, ctx)


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
