Meteor.startup ->
  Logbook._ensureIndex
    recordTime: 1
    deviceId: 1
    type: 1
  #
  # Logbook._ensureIndex
  #   deviceId: 1
  #
  # Logbook._ensureIndex
  #   type: 1

  # Logbook._ensureIndex {loc : "2d"}
