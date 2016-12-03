#!/bin/bash
set -e
npm i --production
meteor build /tmp/fleetr-build --directory --server-only --architecture os.linux.x86_64
cp Dockerfile.prod /tmp/fleetr-build/Dockerfile
docker build -t fleetr/web /tmp/fleetr-build
docker push fleetr/web
