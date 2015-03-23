#!/bin/sh

mongoimport --db meteor --collection logbook --type json --headerline --file %1  -h 127.0.0.1:3001
