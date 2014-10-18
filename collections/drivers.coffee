@Drivers = new Mongo.Collection 'drivers'

Drivers.allow
  remove: -> true
