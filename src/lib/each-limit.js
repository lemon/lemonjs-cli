// inspiration: https://raw.githubusercontent.com/hughsk/map-limit/master/index.js

// wrap a function to only run once
function once (fn) {
  var f = function () {
    if (f.called) return f.value
    f.called = true
    return f.value = fn.apply(this, arguments)
  }
  f.called = false
  return f
}

// empty function
var noop = function noop(){}

// each limit
function eachLimit(arr, limit, iterator, callback) {
  var complete = 0
  var aborted = false
  var queued = 0
  var length = arr.length
  var i = 0

  callback = once(callback || noop)
  if (typeof iterator !== 'function') throw new Error(
    'Iterator function must be passed as the third argument'
  )

  flush()

  function flush() {
    if (complete === length)
      return callback(null)

    while (queued < limit) {
      if (aborted) break
      if (i === length) break
      push()
    }
  }

  function abort(err) {
    aborted = true
    return callback(err)
  }

  function push() {
    var idx = i++

    queued += 1
    iterator(arr[idx], function(err) {
      if (err) return abort(err)
      complete += 1
      queued -= 1
      flush()
    })
  }
}

// export
module.exports = eachLimit;
