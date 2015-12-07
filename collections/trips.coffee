optional = (type) ->
  type: type
  optional: true
  decimal: true

@Trips = new Mongo.Collection 'trips'
Partitioner.partitionCollection Trips

startStopSchema = new SimpleSchema
  lat: optional Number
  lng: optional Number
  recId: optional String
  time: optional Date
  address: optional String
  odometer: optional Number
  fuel: optional Number

Schema.trips = new SimpleSchema
  _id: optional String
  deviceId: optional Number
  date: optional String
  start:
    type: startStopSchema
  stop:
    type: startStopSchema
  distance: optional Number
  fuelConsumed: optional Number
  avgSpeed: optional Number

Trips.attachSchema Schema.trips
