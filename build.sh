#!/bin/bash
set -e
meteor build /tmp/fleetr-build --unsafe-perm --directory --server-only --architecture os.linux.x86_64
(cd /tmp/fleetr-build/bundle/programs/server && npm i --production)
cp Dockerfile /tmp/fleetr-build/
docker build -t fleetr/web -f /tmp/fleetr-build
docker push fleetr/web
