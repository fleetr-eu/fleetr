Meteor.publish 'drivers', () -> Drivers.find {}
Meteor.publish 'countries', () -> Countries.find {}
Meteor.publish 'vehicles', () -> Vehicles.find {}
Meteor.publish 'companies', () -> Companies.find {}, {$sort: {name: 1}}
Meteor.publish 'fleets', () -> Fleets.find {}
Meteor.publish 'expenses', () -> Expenses.find {}
Meteor.publish 'alarms', () -> Alarms.find {}
Meteor.publish 'notifications', () -> Notifications.find {}
# Meteor.publish 'locations', () -> Locations.find {}
Meteor.publish 'driverVehicleAssignments', () -> DriverVehicleAssignments.find {}

Meteor.publish 'locations', (vehicleId, dtFrom, dtTo) ->
  Locations.find {vehicleId: vehicleId} # , $gte: {timestamp: dtFrom*1000}, $lte: {timestamp: dtTo*1000}
  , {sort: {timestamp: -1}}
