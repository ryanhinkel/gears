{ createClass } = require 'react'
{ canvas } = require './elements'

drawSomething = (ctx, x, y) ->
  # Quadratric curves example
  ctx.strokeStyle = "blue"
  ctx.lineWidth = 10
  ctx.beginPath()
  ctx.moveTo(75+x,25+y)
  ctx.quadraticCurveTo(25+x,25+y,25+x,62.5+y)
  ctx.quadraticCurveTo(25+x,100+y,50+x,100+y)
  ctx.quadraticCurveTo(50+x,120+y,30+x,125+y)
  ctx.quadraticCurveTo(60+x,120+y,65+x,100+y)
  ctx.quadraticCurveTo(125+x,100+y,125+x,62.5+y)
  ctx.quadraticCurveTo(125+x,25+y,75+x,25+y)
  ctx.stroke();

drawCanvas = createClass
  draw: (x) ->
    canvas = document.getElementById 'canvas'
    if canvas.getContext
      ctx = canvas.getContext('2d');
      ctx.clearRect(0,0,600,600)
      drawSomething ctx, x, y for y in [0..600]

  animate: () ->
    @draw(@mod)
    @mod += 1
    window.requestAnimationFrame(@animate)

  componentDidMount: () ->
    @mod = 0
    @animate()

  render: () ->
    canvas
      id: 'canvas'
      height: '600px'
      width: '600px'

module.exports = drawCanvas
