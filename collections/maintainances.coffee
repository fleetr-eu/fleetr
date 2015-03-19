@Maintenances = new Mongo.Collection 'maintenances'
Partitioner.partitionCollection Maintenances
Maintenances.attachSchema Schema.maintenances
