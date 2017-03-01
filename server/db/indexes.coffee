Meteor.startup ->
  Vehicles._ensureIndex
    loc: '2dsphere'

  Logbook._ensureIndex
    loc: '2dsphere'

  Logbook._ensureIndex
    'attributes.trip': 1

  Logbook._ensureIndex
    deviceId: 1
    recordTime: 1

  VehicleHistory._ensureIndex
    deviceId: 1
    date: 1
