{ min, max } = Math
reduce = require 'lodash/reduce'
map = require 'lodash/map'
coorTools = require './coordinate_tools'

lastItem = (array) ->
  array[array.length - 1]

splitOnOp = (p) ->
  segments = p.match(/([A-Za-z])[^A-Za-z]+/g)

pathTools = {}

pathTools.convertFromPath = (p) ->
  pathTools.toAbsolute map(splitOnOp(p), (seg) ->
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
  )

pathTools.toPath = (pathObj) ->
  commaJoin = (arr) ->
    arr.join(',')

  mapJoin = (arr, separator, fn) ->
    map(arr, fn).join(separator)

  mapJoin pathObj, '', (seg) ->
    seg.op + mapJoin(seg.coor, ' ', commaJoin)

pathTools.boundingBox = (pathObj) ->
  aJPN = pathTools.toAbsolute(pathObj)
  allCoor =  map aJPN, (seg) ->
    lastItem(seg.coor)
  xmax: max.apply null, map(allCoor, 0)
  xmin: min.apply null, map(allCoor, 0)
  ymax: max.apply null, map(allCoor, 1)
  ymin: min.apply null, map(allCoor, 1)

pathTools.findCenter = (pathObj) ->
  b = pathTools.boundingBox(pathObj)
  [
    (b.xmax+b.xmin)/2
    (b.ymax+b.ymin)/2
  ]

pathTools.toAbsolute = (pathObj) ->
  absolutize = (seg, lastSeg) ->
    relCoor = lastItem(lastSeg.coor)
    op: seg.op.toUpperCase()
    rel: false
    coor: map seg.coor, (coor) ->
      coorTools.vPlusV(coor, relCoor)

  reduce(
    pathObj
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

module.exports = pathTools
