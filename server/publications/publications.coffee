Meteor.startup ->
  # Autopublish
  Meteor.publish null, -> Alarms.find {seen: false}
  # /Autopublish

  Meteor.publish 'countries', -> Countries.find {}
  Meteor.publish 'tyres', (filter = {}) -> Tyres.find filter
  Meteor.publish 'documentTypes', -> DocumentTypes.find {}
  Meteor.publish 'geofenceEvents', -> GeofenceEvents.find {}
  Meteor.publish 'customEvents', -> CustomEvents.find {}
  Meteor.publish 'documents', (driverId) -> Documents.find driverId:driverId
  Meteor.publish 'expenseGroups', -> ExpenseGroups.find {}
  Meteor.publish 'expenseTypes', -> ExpenseTypes.find {}
  Meteor.publish 'expenses', -> Expenses.find {}
  Meteor.publish 'maintenanceTypes', -> MaintenanceTypes.find {}
  Meteor.publish 'insuranceTypes', -> InsuranceTypes.find {}
  Meteor.publish 'insurancePayments', -> InsurancePayments.find {}
  Meteor.publish 'insurances', -> Insurances.find {}
  Meteor.publish 'maintenanceType', (id) -> MaintenanceTypes.find _id: id
  Meteor.publish 'vehicleMaintenances', (vehicleId)-> Maintenances.find {vehicle: vehicleId}
  Meteor.publish 'vehicleOdometers', (vehicleId)-> Odometers.find {vehicleId: vehicleId}
  Meteor.publish 'alarms', -> Alarms.find {}
  Meteor.publish 'notifications', -> Notifications.find {}
  Meteor.publish 'geofences', (filter) -> Geofences.findFiltered filter, ['name', 'tags']
  Meteor.publish 'driverVehicleAssignments', -> DriverVehicleAssignments.find {}
  Meteor.publish 'driverVehicleAssignment', (filter) -> if filter then DriverVehicleAssignments.find filter else []
  Meteor.publish 'aggbydate', (args) -> AggByDate.find(args || {})
  Meteor.publish 'latest device position', (deviceId) -> Logbook.find {deviceId: deviceId}, {sort: {recordTime: -1}, limit: 1}
  Meteor.publish 'idlebook'  , (args) -> IdleBook.find(args || {}, {sort: {startTime: 1}} )
  Meteor.publish 'trips', (args) -> Trips.find(args || {}, {sort: {startTime: 1}} )
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

  Meteor.publish 'alarm-definitions', -> AlarmDefinitions.find {}

  Meteor.publish 'logbook', (searchArgs = {}) -> Logbook.find searchArgs, {sort: recordTime: -1}

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
