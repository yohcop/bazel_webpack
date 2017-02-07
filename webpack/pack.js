#!/usr/bin/env node

process.env.NODE_PATH = process.cwd() + ':' + process.env.NODE_PATH + ':' + process.env.EXTRA_NODE_PATH;
require("module").Module._initPaths();

if (1 == 1) {  // debug only...
  console.log("CWD: " +process.cwd());
  console.log("MAIN: " + require.main.filename);
  console.log("NODE_PATH: " + process.env.NODE_PATH);
  const fs = require('fs');
  files = fs.readdirSync('./fitzenith/web');
  files.forEach(file => {
    console.log(file);
  });
}

// Get the configuration object.
const cfg = require(process.env.WEBPACK_CFG);
console.log(cfg);

const webpack = require("webpack");
webpack(cfg, (err, stats) => {
  if (err) {
    console.log("Errors:");
    console.error(err.stack || err);
    if (err.details) {
      console.log("Details:");
      console.error(err.details);
    }
    process.exit(1);
    return;
  }

  const info = stats.toJson();

  if (stats.hasErrors()) {
    console.error("Compile errors (first 3)");
    console.error(info.errors.slice(0, 3).join("\n\n\n"));
    process.exit(1);
  }

  if (stats.hasWarnings()) {
    console.warn("Compile warnings");
    console.warn(info.warnings)
    process.exit(1);
  }

});
