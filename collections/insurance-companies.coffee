@InsuranceCompanies = new Mongo.Collection 'insuranceCompanies'
Partitioner.partitionCollection InsuranceCompanies
InsuranceCompanies.attachSchema Schema.insuranceCompanies