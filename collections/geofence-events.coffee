@GeofenceEvents = new Mongo.Collection 'geofenceEvents'
Partitioner.partitionCollection GeofenceEvents
GeofenceEvents.attachSchema Schema.geofenceEvents