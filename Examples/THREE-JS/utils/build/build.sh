#!/bin/sh

python build.py --include sea3d --output ../../build/loaders/Sea3dLoader.js
python build.py --include sea3d --minify --output ../../build/loaders/Sea3dLoader.min.js
