@Maintainances = new Mongo.Collection 'vechileMaintainances'
Partitioner.partitionCollection Maintainances
Maintainances.attachSchema Schema.maintainances
