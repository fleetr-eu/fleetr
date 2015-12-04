@CustomEvents = new Mongo.Collection 'customEvents'
Partitioner.partitionCollection CustomEvents
CustomEvents.attachSchema Schema.customEvents