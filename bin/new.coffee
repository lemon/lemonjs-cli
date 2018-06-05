
# set env
global.LEMON_ENV = 'dev'

# dependencies
Path = require 'path'
mkdirp = require 'mkdirp'
fs = require 'fs'

# local dependencies
fail = require Path.resolve __dirname, '..', 'src', 'utils', 'fail'
walk = require Path.resolve __dirname, '..', 'src', 'utils', 'walk'

# setup
setup = (argv) ->
  console.info 'setting up your project'

  # make sure current directory is empty
  project_dir = Path.resolve '.'
  files = walk project_dir
  if files.length > 0
    fail "you must be in an empty directory to create a lemon project"

  # get template name
  template_name = argv._[1] or 'default'

  # check if template exists
  template_dir = Path.resolve __dirname, '..', 'templates', template_name
  exists = fs.existsSync template_dir
  if not exists
    fail "template #{template_name} does not exist"

  # copy template to current directory
  for file in walk template_dir
    path = file.replace "#{template_dir}/", ''
    dst = "#{project_dir}/#{path}"
    mkdirp.sync Path.dirname dst
    contents = fs.readFileSync file
    contents = fs.readFileSync file
    fs.writeFileSync dst, contents
  console.info 'your project is ready to start'
  console.info '`lemon dev` to start developing'

# export
module.exports = setup
