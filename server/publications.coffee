Meteor.publish 'drivers', () -> Drivers.find {}
Meteor.publish 'countries', () -> Countries.find {}
Meteor.publish 'vehicles', () -> Vehicles.find {}
Meteor.publish 'companies', () -> Companies.find {}, {$sort: {name: 1}}
Meteor.publish 'fleets', () -> Fleets.find {}
Meteor.publish 'expenses', () -> Expenses.find {}
Meteor.publish 'notifications', () -> Notifications.find {}
# Meteor.publish 'locations', () -> Locations.find {}
Meteor.publish 'driverVehicleAssignments', () -> DriverVehicleAssignments.find {}

Meteor.publish 'locations', (vehicleId) ->
  Locations.find {vehicleId: vehicleId}, {sort: {timestamp: -1}} #, loc: {$within : {$box : area}}
