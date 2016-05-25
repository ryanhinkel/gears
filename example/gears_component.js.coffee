{ createClass, createFactory } = require 'react'
{ div, canvas } = require '../lib/elements'

gearsPaths = require './assets/gear_paths'
gearRotate = require '../src/main'

gearCanvas = createClass
  setRef: (ref) ->
    # once dom element is ready
    # canvas rendering context
    ctx = ref.getContext("2d")

    # resolution independance
    ctx.scale(@pixelRatio, @pixelRatio)

    # create function to draw gear
    drawGear = gearRotate(ctx, gearsPaths)

    # use requestAnimationFrame
    draw = () ->
      requestAnimationFrame () ->
        drawGear([document.body.scrollTop])

    # set up handler and draw immediately
    window.onscroll = draw
    draw()

  render: () ->
    # render dom element
    # canvas attributes
    canvasWidth = 1000
    canvasHeight = 1000

    # resolution independance
    @pixelRatio = window.devicePixelRatio
    canvasWidth *= window.devicePixelRatio;
    canvasHeight *= window.devicePixelRatio;

    # render canvas element with pixel ratio scaling
    canvas
      className: 'gears'
      width: canvasWidth
      height: canvasHeight
      ref: this.setRef

module.exports = createFactory gearCanvas
