logMigrationErrors = (err) ->
  if err
    console.error 'MIGRATION ERROR: ', err

Migrations.add
  version: 1
  name: 'Renames lon to lng in Logbook and Vehicles.'
  up: ->
    Partitioner.directOperation ->
      Vehicles.update {lon: $exists: true}, {$rename: 'lon': 'lng'}, {multi: true}, logMigrationErrors
      Logbook.update {lon: $exists: true}, {$rename: 'lon': 'lng'}, {multi: true}, logMigrationErrors

Migrations.add
  version: 2
  name: 'Renames tacho to odometer in Logbook.'
  up: ->
    Partitioner.directOperation ->
      Logbook.update {tacho: $exists: true}, {$rename: 'tacho': 'odometer'}, {multi: true}, logMigrationErrors

Meteor.startup ->
  Migrations.migrateTo 'latest'
