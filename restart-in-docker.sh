#!/bin/sh
/usr/bin/docker rm $(/usr/bin/docker stop $(/usr/bin/docker ps -aq))
/usr/local/bin/docker-compose up &
