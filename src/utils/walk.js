// https://gist.github.com/kethinov/6658166#gistcomment-2153836

// dependencies
const fs = require('fs');
const path = require('path');

// list all files in a directory
const walk = (dir) =>
  fs.readdirSync(dir).reduce((files, file) =>
    fs.statSync(path.join(dir, file)).isDirectory() ?
      files.concat(walk(path.join(dir, file))) :
      files.concat(path.join(dir, file)),
    []);

// export
module.exports = walk;
