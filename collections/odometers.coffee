@Odometers = new Mongo.Collection 'odometers'
Partitioner.partitionCollection Odometers
Odometers.attachSchema Schema.odometers