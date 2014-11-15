Meteor.publish 'drivers', () -> Drivers.find {}
Meteor.publish 'countries', () -> Countries.find {}
Meteor.publish 'vehicles', () -> Vehicles.find {}
Meteor.publish 'vehiclesMakes', () -> VehiclesMakes.find {}
Meteor.publish 'vehiclesModels', () -> VehiclesModels.find {}
Meteor.publish 'fleetGroups', () -> FleetGroups.find {}, {$sort: {name: 1}}
Meteor.publish 'fleets', () -> Fleets.find {}
Meteor.publish 'expenses', () -> Expenses.find {}
Meteor.publish 'alarms', () -> Alarms.find {}
Meteor.publish 'notifications', () -> Notifications.find {}
# Meteor.publish 'locations', () -> Locations.find {}
Meteor.publish 'driverVehicleAssignments', () -> DriverVehicleAssignments.find {}

Meteor.publish 'locations', (vehicleId, dtFrom, dtTo) ->
  Locations.find {vehicleId: vehicleId, timestamp: {$gte: dtFrom*1000, $lte: dtTo*1000}}, {sort: {timestamp: -1}}
