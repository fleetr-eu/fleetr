@Drivers = new Mongo.Collection 'drivers'

Drivers.attachSchema Schema.driver
