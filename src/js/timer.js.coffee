timer = null

module.exports =
  start: () ->
    timer = new Date().valueOf()

  stop: (log=true) ->
    result = new Date().valueOf() - timer
    if log then console.log(result)
    result
