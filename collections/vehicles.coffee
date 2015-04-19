@Vehicles = new Mongo.Collection 'vehicles'
Partitioner.partitionCollection Vehicles
Vehicles.attachSchema Schema.vehicle

Vehicles.after.remove (userId, doc) ->
  if doc._id
    Locations.remove {vehicleId:doc._id}

Vehicles.getAssignedDriver = (vehicle, timestamp) ->
  dvAssignment = DriverVehicleAssignments.findOne {vehicle:vehicle},  {sort: {moment: -1}}
  if (dvAssignment?.date <= timestamp) and (dvAssignment?.event=='begin')
    dvAssignment.driver
  else
    ""

Vehicles.getAssignedDriverByUnitId = (unitId, timestamp) ->
  vehicle = Vehicles.findOne {unitId: unitId}
  driverId = Vehicles.getAssignedDriver(vehicle._id, timestamp)
  Drivers.findOne({_id: driverId})

Vehicles.helpers
  lastLocations: (limit) ->
    if limit
      Logbook.find {unitId: @deviceId}, {sort: {recordTime: -1}, limit: limit}
    else
      Logbook.find {unitId: @deviceId}, {sort: {recordTime: -1}}
