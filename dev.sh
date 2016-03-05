#!/bin/bash

docker run --name mongo-dev -d mongo || docker start mongo-dev
docker rm fleetr-dev; docker run --name fleetr-dev -it --rm -p 3000:3000 -v "$(pwd)":/app --link mongo-dev:db -e "MONGO_URL=mongodb://db" danieldent/meteor

