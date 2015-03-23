#!/bin/sh

mongoexport --db meteor --collection logbook --host localhost --port 3001 > $1
