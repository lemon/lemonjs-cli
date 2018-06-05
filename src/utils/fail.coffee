
# log an error and terminate the process
fail = (err) ->
  console.error err
  process.exit 1

# export
module.exports = fail
