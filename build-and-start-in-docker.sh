#!/bin/sh
docker rm $(docker stop $(docker ps -aq))
docker-compose up
