@Vehicles = new Mongo.Collection 'vehicles'

Countries.allow
  insert: -> true
