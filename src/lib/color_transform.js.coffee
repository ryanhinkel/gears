module.exports =
  componentToHex: (c) ->
    hex = c.toString(16)
    if hex.length is 1 then "0" + hex else hex

  rgbToHex: (r, g, b) ->
    '#' + componentToHex(r) + componentToHex(g) + componentToHex(b)


  hexToRgb: (hex) ->
    result = /^#?([a-f\d]{2})([a-f\d]{2})([a-f\d]{2})$/i.exec(hex)
    if not result
      null
    else
      r: parseInt(result[1], 16)
      g: parseInt(result[2], 16)
      b: parseInt(result[3], 16)
