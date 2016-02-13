@Alarms = new Mongo.Collection 'alarms'
Partitioner.partitionCollection Alarms
Alarms.attachSchema Schema.alarms


fetchGfAlarmObjects = (alarm) ->
  vehicle: Vehicles.findOne(_id: alarm.data.vehicleId)
  geofence: Geofences.findOne(_id: alarm.data.geofenceId)

makeAlarmText = (alarm) ->
  switch alarm.type
    when 'geofence:enter'
      {vehicle, geofence} = fetchGfAlarmObjects alarm
      "Автомобил #{vehicle.name} влезе в обект #{geofence.name}."
    when 'geofence:exit'
      {vehicle, geofence} = fetchGfAlarmObjects alarm
      "Автомобил #{vehicle.name} излезе от обект #{geofence.name}."

Alarms.add = (alarm) ->
  Alarms.insert _.extend alarm,
    timestamp: new Date()
    seen: false
    description: makeAlarmText alarm
