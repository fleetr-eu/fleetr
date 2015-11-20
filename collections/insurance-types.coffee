@InsuranceTypes = new Mongo.Collection 'insuranceTypes'
Partitioner.partitionCollection InsuranceTypes
InsuranceTypes.attachSchema Schema.insuranceTypes
