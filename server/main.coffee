Meteor.publish 'drivers', () -> Drivers.find {}
Meteor.publish 'countries', () -> Countries.find {}
Meteor.publish 'vehicles', () -> Vehicles.find {}
Meteor.publish 'companies', () -> Companies.find {}
Meteor.publish 'fleets', () -> Fleets.find {}
Meteor.publish 'locations', (geobox) ->
  if geobox
    Locations.find({loc: {$within : {$box : geobox}}})
  else []

Meteor.startup -> Locations._ensureIndex { loc : "2d" }
