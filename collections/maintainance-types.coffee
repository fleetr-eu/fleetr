@MaintainanceTypes = new Mongo.Collection 'maintainanceTypes'
Partitioner.partitionCollection MaintainanceTypes
MaintainanceTypes.attachSchema Schema.maintainanceTypes
