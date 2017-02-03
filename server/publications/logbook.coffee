Meteor.publish 'logbook/trip', (tripId) ->
  if tripId
    Logbook.find {'attributes.trip': tripId}, {sort: {recordTime: 1}}
  else
    []

Meteor.publish 'idlebook', (args) ->
  IdleBook.find(args || {}, {sort: {startTime: 1}} )

Meteor.publish 'trips', (args) ->
  Trips.find(args || {}, {sort: {startTime: 1}})

Meteor.publish 'tripsOfVehicle', (vehicleId, since) ->
  deviceId = Vehicles.findOne(_id: vehicleId).unitId
  query = deviceId: deviceId
  if since
    query['start.time'] = $gte: since
  Trips.find query,
    sort:
      startTime: 1
    fields:
      path: 0

Meteor.publish 'restsOfVehicle', (vehicleId) ->
  deviceId = Vehicles.findOne(_id: vehicleId).unitId
  Rests.find {deviceId: deviceId}, {sort: {startTime: 1}}

Meteor.publish 'logbook', (searchArgs = {}) ->
  Logbook.find searchArgs, {sort: recordTime: -1}
