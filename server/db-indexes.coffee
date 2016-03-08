Meteor.startup ->
  Vehicles._ensureIndex
    loc: '2dsphere'

  Logbook._ensureIndex
    deviceId: 1
    offset: 1

  Logbook._ensureIndex
    type: 1

  Logbook._ensureIndex
    deviceId: 1
    type: 1
    recordTime: 1
