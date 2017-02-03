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
Meteor.publish 'maintenanceType', (id) -> MaintenanceTypes.find _id: id
Meteor.publish 'vehicleMaintenances', (vehicleId)-> Maintenances.find {vehicle: vehicleId}
Meteor.publish 'vehicleOdometers', (vehicleId)-> Odometers.find {vehicleId: vehicleId}
Meteor.publish 'alarms', -> Alarms.find {}
Meteor.publish 'notifications', -> Notifications.find {}
Meteor.publish 'geofences', (filter) -> Geofences.findFiltered filter, ['name', 'tags']
Meteor.publish 'driverVehicleAssignments', -> DriverVehicleAssignments.find {}
Meteor.publish 'driverVehicleAssignment', (filter) -> if filter then DriverVehicleAssignments.find filter else []
Meteor.publish 'latest device position', (deviceId) -> Logbook.find {deviceId: deviceId}, {sort: {recordTime: -1}, limit: 1}
Meteor.publish 'alarm-definitions', -> AlarmDefinitions.find {}
