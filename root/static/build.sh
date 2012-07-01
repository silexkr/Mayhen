#!/bin/sh
rm -rf scripts.min
rm -rf css.min
r.js -o scripts/app.build.js
r.js -o css/css.build.js
