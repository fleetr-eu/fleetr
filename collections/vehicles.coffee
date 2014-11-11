@Vehicles = new Mongo.Collection 'vehicles'

Vehicles.attachSchema Schema.vehicle

Vehicles.after.remove (userId, doc) ->
  if doc._id
    Locations.remove {vehicleId:doc._id}

Vehicles.helpers
  lastLocations: (limit) ->
    if limit
      Locations.find {vehicleId: @_id}, {sort: {timestamp: -1}, limit: limit}
    else
      Locations.find {vehicleId: @_id}, {sort: {timestamp: -1}}
