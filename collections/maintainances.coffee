@Maintenances = new Mongo.Collection 'vehicleMaintenances'
Partitioner.partitionCollection Maintenances
Maintenances.attachSchema Schema.maintenances
