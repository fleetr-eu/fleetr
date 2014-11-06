@Vehicles = new Mongo.Collection 'vehicles'

Vehicles.attachSchema Schema.vehicle

Vehicles.after.remove (userId, doc) ->
  if doc._id
    Locations.remove {vehicleId:doc._id}

Vehicles.helpers
  lastLocation: ->
    Locations.findOne {vehicleId: @_id}, {sort: {timestamp: -1}}
