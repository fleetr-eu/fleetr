Meteor.publish 'drivers', -> Drivers.find {}
Meteor.publish 'driversForVehiclesList', ->
  Drivers.find {},
    fields:
      name: 1
      lastName: 1
Meteor.publish 'driver', (filter) -> if filter then Drivers.find(filter) else []
