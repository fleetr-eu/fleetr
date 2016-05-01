logMigrationErrors = (err) ->
  if err
    console.error 'MIGRATION ERROR: ', err

Migrations.add
  version: 1
  name: 'Renames lon to lng in Logbook and Vehicles.'
  up: ->
    Partitioner.directOperation ->
      Vehicles.update {lon: $exists: true}, {$rename: 'lon': 'lng'}, logMigrationErrors
      Logbook.update {lon: $exists: true}, {$rename: 'lon': 'lng'}, logMigrationErrors

Meteor.startup ->
  Migrations.migrateTo 'latest'
