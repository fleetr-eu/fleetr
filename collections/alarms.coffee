@Alarms = new Mongo.Collection 'alarms'
Partitioner.partitionCollection Alarms
Alarms.attachSchema Schema.alarms