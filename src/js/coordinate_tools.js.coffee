reduce = require 'lodash/reduce'
map = require 'lodash/map'
{ cos, sin, PI, min, max } = Math

lastItem = (array) ->
  array[array.length - 1]

radians = (d) ->
  d * (PI / 180)

# Public

ct = {}

ct.rotateMatrix = (theta) ->
  c = cos(theta)
  s = sin(theta)
  [
    [c, -s],
    [s,  c]
  ]

ct.reflectYMatrix = () ->
  [
    [1,  0],
    [0, -1]
  ]

# Matrix math

ct.vTimesM = (v, m) ->
  [
    m[0][0] * v[0] + m[0][1] * v[1],
    m[1][0] * v[0] + m[1][1] * v[1]
  ]

ct.vPlusV = (v1, v2) ->
  [
    v1[0] + v2[0],
    v1[1] + v2[1]
  ]

ct.vMinusV = (v1, v2) ->
  [
    v1[0] - v2[0],
    v1[1] - v2[1]
  ]

ct.rotateVector = (v, theta) ->
  ct.vTimesM(v, ct.rotateMatrix(theta))

ct.rotateAround = (v1, v2, theta) ->
  # v2 rotates around v1
  ct.vPlusV(ct.rotateVector(ct.vMinusV(v2, v1), theta), v1)

# Path inputs

splitOnOp = (p) ->
  segments = p.match(/([A-Za-z])[^A-Za-z]+/g)

ct.toJPN = (p) ->
  map splitOnOp(p), (seg) ->
    op = seg.slice 0,1
    rel = op is op.toLowerCase()
    coor =
      map seg.slice(1).split(' '), (pair) ->
        map pair.split(','), parseFloat

    {
      op: op
      rel: rel
      coor: coor
    }

# JPN inputs

ct.toPath = (jpn) ->
  commaJoin = (arr) ->
    arr.join(',')

  mapJoin = (arr, separator, fn) ->
    map(arr, fn).join(separator)

  mapJoin jpn, '', (seg) ->
    seg.op + mapJoin(seg.coor, ' ', commaJoin)

ct.boundingBox = (jpn) ->
  aJPN = ct.toAbsolute(jpn)
  allCoor =  map aJPN, (seg) ->
    lastItem(seg.coor)
  xmax: max.apply null, map(allCoor, 0)
  xmin: min.apply null, map(allCoor, 0)
  ymax: max.apply null, map(allCoor, 1)
  ymin: min.apply null, map(allCoor, 1)

ct.findCenter = (jpn) ->
  b = ct.boundingBox(jpn)
  [
    (b.xmax+b.xmin)/2
    (b.ymax+b.ymin)/2
  ]

ct.toAbsolute = (jpn) ->
  absolutize = (seg, lastSeg) ->
    relCoor = lastItem(lastSeg.coor)
    op: seg.op.toUpperCase()
    rel: false
    coor: map seg.coor, (coor) ->
      ct.vPlusV(coor, relCoor)

  reduce(
    jpn
    (result, seg) ->
      # test if coordinate is absolute or relative
      if seg.rel
        lastSeg = lastItem(result)
        result.push absolutize(seg, lastSeg)
      else
        result.push seg
      result
    []
  )

# JPN transform

ct.rotateJPN = (jpn, point, angle) ->
  reduce(
    jpn
    (result, seg) ->
      transformed =
        coor: map(seg.coor, (coor) -> ct.rotateAround(point, coor, angle))
        op: seg.op
      result.push(transformed)
      result
    []
  )

module.exports = ct
