@MaintenanceTypes = new Mongo.Collection 'maintenanceTypes'
Partitioner.partitionCollection MaintenanceTypes
MaintenanceTypes.attachSchema Schema.maintenanceTypes
