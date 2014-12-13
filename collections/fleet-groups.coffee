@FleetGroups = new Mongo.Collection 'fleetGroups'
Partitioner.partitionCollection FleetGroups
FleetGroups.attachSchema Schema.fleetGroups
