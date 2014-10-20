@Vehicles = new Mongo.Collection 'vehicles'

Vehicles.attachSchema Schema.vehicle

Vehicles.allow
  insert: -> true
