@Vehicles = new Mongo.Collection 'vehicles'
Partitioner.partitionCollection Vehicles
Vehicles.attachSchema Schema.vehicle

Vehicles.after.update (userId, doc, fieldNames, modifier, options) ->
   if doc.nextTechnicalCheck
    event = CustomEvents.findOne { sourceId: doc._id }
    if event 
      CustomEvents.update(event._id, { $set: { date: doc.nextTechnicalCheck, active: doc.active}} )
    else
      CustomEvents.insert
        sourceId: doc._id
        name: "Технически преглед"
        kind: "Технически преглед"
        date: doc.nextTechnicalCheck
        vehicleId: doc._id
        active: doc.active
        seen: false  

Vehicles.after.insert (userId, doc) ->
  if doc.nextTechnicalCheck
    CustomEvents.insert
      sourceId: doc._id
      name: "Технически преглед"
      kind: "Технически преглед"
      date: doc.nextTechnicalCheck
      vehicleId: doc._id
      active: doc.active
      seen: false

Vehicles.getAssignedDriver = (vehicle, timestamp) ->
  dvAssignment = DriverVehicleAssignments.findOne {vehicle:vehicle},  {sort: {moment: -1}}
  if (dvAssignment?.date <= timestamp) and (dvAssignment?.event=='begin')
    dvAssignment.driver
  else
    ""

Vehicles.getAssignedDriverByUnitId = (unitId, timestamp) ->
  vehicle = Vehicles.findOne {unitId: unitId}
  return undefined if not vehicle
  driverId = Vehicles.getAssignedDriver(vehicle._id, timestamp)
  return undefined if not driverId
  Drivers.findOne({_id: driverId})
