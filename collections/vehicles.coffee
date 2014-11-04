@Vehicles = new Mongo.Collection 'vehicles'

Vehicles.attachSchema Schema.vehicle

Vehicles.allow
  insert: -> true

Vehicles.after.remove (userId, doc) ->
  if doc._id
    Locations.remove {vehicleId:doc._id}
