@Vehicles = new Mongo.Collection 'vehicles'

Vehicles.attachSchema Schema.vehicle

Vehicles.after.remove (userId, doc) ->
  if doc._id
    Locations.remove {vehicleId:doc._id}

Vehicles.getAssignedDriver = (vehicle, timestamp) ->
  dvAssignment = DriverVehicleAssignments.findOne {vehicle:vehicle},  {sort: {moment: -1}}
  if (dvAssignment?.moment <= timestamp) and (dvAssignment?.event=='begin')
    dvAssignment.driver
  else
    ""

Vehicles.helpers
  lastLocations: (limit) ->
    if limit
      Locations.find {vehicleId: @_id}, {sort: {timestamp: -1}, limit: limit}
    else
      Locations.find {vehicleId: @_id}, {sort: {timestamp: -1}}
