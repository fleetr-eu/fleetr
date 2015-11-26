@Insurances = new Mongo.Collection 'insurances'
Partitioner.partitionCollection Insurances
Insurances.attachSchema Schema.insurance
