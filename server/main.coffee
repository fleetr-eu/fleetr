Meteor.publish 'drivers', () -> Drivers.find {}
Meteor.publish 'countries', () -> Countries.find {}
Meteor.publish 'vehicle', () -> Vehicles.find {}
