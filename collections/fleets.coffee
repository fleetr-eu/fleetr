@Fleets = new Mongo.Collection 'fleets'
Partitioner.partitionCollection Fleets
Fleets.attachSchema Schema.fleet
