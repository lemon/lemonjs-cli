
# read args
Path = require 'path'
minimist = require 'minimist'

# read command line args
argv = minimist process.argv.slice 2

# handle command
switch argv._[0]

  when 'build'
    require(Path.resolve __dirname, 'build')(argv)

  when 'deploy'
    require(Path.resolve __dirname, 'deploy')(argv)

  when 'dev'
    require(Path.resolve __dirname, 'dev')(argv)

  when 'new'
    require(Path.resolve __dirname, 'new')(argv)

  when 'run'
    require(Path.resolve __dirname, 'run')(argv)

  else
    console.info "invalid command. must be (new|dev|build|deploy|run)"
