@Maintenances = new Mongo.Collection 'vechileMaintenances'
Partitioner.partitionCollection Maintenances
Maintenances.attachSchema Schema.maintenances
