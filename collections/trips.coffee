optional = (type) ->
  type: type
  optional: true

@Trips = new Mongo.Collection 'trips'
Partitioner.partitionCollection Trips
Schema.trips = new SimpleSchema
  _id: optional String
  deviceId: optional Number
  startRecId: optional String
  stopRecId: optional String
  date: optional String
  startTime: optional Date
  startAddress: optional String
  startOdometer: optional Number
  startFuel: optional Number
  stopTime: optional Date
  stopAddress: optional String
  stopOdometer: optional Number
  stopFuel: optional Number
  distance:
    type: Number
    optional: true
    decimal: true
  fuelConsumed:
    type: Number
    optional: true
    decimal: true
  avgSpeed:
    type: Number
    optional: true
    decimal: true

Trips.attachSchema Schema.trips
