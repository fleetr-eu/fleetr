opts =
  fields:
    name: 1
    licensePlate: 1
    allocatedToFleet: 1
    speed: 1
    state: 1
    driver_id: 1
    odometer: 1
    lastUpdate: 1
    tags: 1
    unitId: 1
    tripTime: 1
    idleTime: 1
    restTime: 1
    lat: 1
    lng: 1
    course: 1
    # for editing, needs another pub per vehicle
    address: 1
    active: 1
    allocatedToFleetFromDate: 1
    make: 1
    nextTechnicalCheck: 1
    phoneNumber: 1
    mass: 1
    maxFuelCapacity: 1
    engineDisplacement: 1
    body: 1
    productionYear: 1
    fuelType: 1
    maxPower: 1
    kind: 1
    makeAndModel: 1
    category: 1
    engineHours: 1
    color: 1
    engineNumber: 1
    identificationNumber: 1
    courseCorrection: 1
    maxSpeed: 1
    maxAllowedSpeed: 1
    workHours: 1

findVehicles = (filter = {}) ->
  Vehicles.find PermissionsManager.augment(filter, 'vehicles'), opts

Meteor.publish 'vehicles/licensePlates', ->
  Vehicles.find {}, fields:
    licensePlate: 1
Meteor.publish 'vehicles', findVehicles
Meteor.publish 'vehicle', (filter) ->
  if filter then Vehicles.find(filter) else []
Meteor.publish 'vehicles/list', findVehicles
Meteor.publish 'vehicle/history', (vehicleId) ->
  if v = Vehicles.findOne(_id: vehicleId)
    VehicleHistory.find {deviceId: v.unitId}, {sort: date: -1}
  else []

publishVehicleNames = (filter = {}) ->
  Vehicles.find PermissionsManager.augment(filter, 'vehicles'),
    fields:
      name: 1
      licensePlate: 1

Meteor.publish 'vehicles/names', publishVehicleNames

Meteor.publish 'vehicle/name', (vehicleId) ->
  publishVehicleNames _id: vehicleId


Meteor.publish 'vehicleInfo', (unitId) ->
  vehiclesCursor = Vehicles.find unitId: "#{unitId}"
  v = vehiclesCursor.fetch()[0]
  fleetsCursor = Fleets.find _id: v?.allocatedToFleet
  [
    vehiclesCursor
    Drivers.find vehicle_id: v?._id
    fleetsCursor
    FleetGroups.find _id: fleetsCursor.fetch()[0]?.parent
  ]
