@InsurancePayments = new Mongo.Collection 'insurancePayments'
Partitioner.partitionCollection InsurancePayments
InsurancePayments.attachSchema Schema.insurancePayment
