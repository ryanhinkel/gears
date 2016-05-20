{ cos, sin, PI } = Math

radians = (d) ->
  d * (PI / 180)

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

module.exports = ct
