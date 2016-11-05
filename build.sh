#!/bin/sh
# docker run --rm -it -v ${PWD}:/source -v /tmp:/build greyarch/meteor-build \
#   bash -c "rm -rf node_modules; npm i --production; \
#           meteor build /build --directory --unsafe-perm --server-only --architecture os.linux.x86_64; \
#           cp /source/Dockerfile.prod /build/bundle/Dockerfile; \
#           cp /source/package.json /build/bundle/"
# rm -rf node_modules
# npm i --production
meteor build /tmp/fleetr-build --directory --server-only --architecture os.linux.x86_64
cd /tmp/fleetr-build/bundle/programs/server
npm i --production
cp Dockerfile /tmp/fleetr-build/
cd /tmp/fleetr-build
docker build -t fleetr/web .
docker push fleetr/web
