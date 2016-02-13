@Alarms = new Mongo.Collection 'alarms'
Partitioner.partitionCollection Alarms
Alarms.attachSchema Schema.alarms

Alarms.timeAgoStyle = (timestamp) ->
  if moment(timestamp).add(1, "hours").toDate() < moment()
    "color:red;"
  else
    if moment(timestamp).add(30, "minutes").toDate() < moment()
      "color:orange;"
    else
      "color:navy;"

fetchGfAlarmObjects = (alarm) ->
  vehicle: Vehicles.findOne(_id: alarm.data.vehicleId)
  geofence: Geofences.findOne(_id: alarm.data.geofenceId)

makeAlarmText = (alarm) ->
  switch alarm.type
    when 'geofence:enter'
      {vehicle, geofence} = fetchGfAlarmObjects alarm
      "Автомобил #{vehicle.name} (#{vehicle.licensePlate}) влезе в обект #{geofence.name}."
    when 'geofence:exit'
      {vehicle, geofence} = fetchGfAlarmObjects alarm
      "Автомобил #{vehicle.name} (#{vehicle.licensePlate}) излезе от обект #{geofence.name}."

Alarms.add = (alarm) ->
  Alarms.insert _.extend alarm,
    timestamp: new Date()
    seen: false
    description: makeAlarmText alarm
