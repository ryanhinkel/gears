reduce = require 'lodash/reduce'
map = require 'lodash/map'
{ cos, sin, PI } = Math


exports.radians = (d) ->
  d * (PI / 180)

exports.rotateMatrix = (theta) ->
  c = cos(theta)
  s = sin(theta)
  [
    [c, -s],
    [s,  c]
  ]

exports.reflectYMatrix = () ->
  [
    [1,  0],
    [0, -1]
  ]

# Matrix math

exports.vTimesM = (v, m) ->
  [
    m[0][0] * v[0] + m[0][1] * v[1],
    m[1][0] * v[0] + m[1][1] * v[1]
  ]

exports.vPlusV = (v1, v2) ->
  [
    v1[0] + v2[0],
    v1[1] + v2[1]
  ]

exports.vMinusV = (v1, v2) ->
  [
    v1[0] - v2[0],
    v1[1] - v2[1]
  ]

exports.rotateVector = (v, theta) ->
  vectorTimesMatrix(v, rotateMatrix(theta))

exports.rotateAround = (v1, v2, theta) ->
  # v2 rotates around v1
  vPlusV(rotateVector(vMinusV(v2, v1), theta), v2)

# Path tools

exports.toAbsolutePath = (p) ->
  first = (string, l=1) ->
    string.slice(0,l)

  rest = (string) ->
    string.slice(1)

  splitCoords = (string) ->
    map string.split(' '), (pair) ->
      map pair.split(','), parseFloat

  joinCoords = (array) ->
    map(array, (pair) -> pair.join(',')).join(' ')

  absoluteSegment = (value, lastValue) ->
    op = first(value)
    lastSegment = splitCoords(rest(lastValue))
    lastPoint = lastSegment[lastSegment.length-1]
    segment = splitCoords(rest(value))
    absolutized = map segment, (coord) ->
      exports.vPlusV(coord, lastPoint)

    op.toUpperCase() + joinCoords(absolutized)


  segments = p.match(/([A-Za-z])[^A-Za-z]+/g)
  reduce(
    segments
    (result, value) ->
      # test if coordinate is absolute or relative
      if first(value) is first(value).toLowerCase()
        lastValue = result[result.length-1]
        result.push absoluteSegment(value, lastValue)
      else
        result.push value
      result
    []
  ).join('')
