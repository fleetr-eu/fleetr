@Alarms = new Mongo.Collection 'alarms'
Partitioner.partitionCollection Alarms

Alarms.timeAgoStyle = (timestamp) ->
  if moment(timestamp).add(1, "hours").toDate() < moment()
    "color:red;"
  else
    if moment(timestamp).add(30, "minutes").toDate() < moment()
      "color:orange;"
    else
      "color:navy;"

Alarms.findFiltered = (term, unseenOnly) ->
  filter = {}
  if term
    query = term.replace ' ', '|'
    rx =
      $options: 'i'
      $regex: query
    filter['$or'] = [{alarmText: rx}, {tags: rx}]
  if unseenOnly then filter.seen = false
  Alarms.find filter

Alarms.alarmText = (alarm) ->
  vehicle = Vehicles.findOne _id: alarm.vehicle
  licensePlate = ""
  if vehicle
    licensePlate = vehicle.licensePlate
  switch alarm.type
    when "overspeeding"
      "Превишена скорост: #{licensePlate} скорост: #{Math.round(alarm.speed)} км/ч"
    when "longStay"
      "Продължителен престой: #{licensePlate} време: #{moment.duration(alarm.stay,'seconds').humanize()}"
    when "unasignedDriver"
      "Кола без асоцииран шофьор: #{licensePlate}"

Alarms.addAlarms = (doc) ->
  if doc.speed > Settings.maxSpeed
    alarm =
      type: "overspeeding"
      vehicle: doc.vehicleId
      driver: doc.driverId
      speed: doc.speed
      loc: doc.loc
      seen: false
      timestamp: Date.now()
    alarm.alarmText = Alarms.alarmText (alarm)
    Alarms.insert alarm

  if doc.stay > Settings.maxStay
    alarm =
      type: "longStay"
      vehicle: doc.vehicleId
      driver: doc.driverId
      stay: doc.stay
      loc: doc.loc
      seen: false
      timestamp: Date.now()
    alarm.alarmText = Alarms.alarmText (alarm)
    Alarms.insert alarm

  if (!doc.driver) and (doc.speed > 0)
    alarm =
      type: "unasignedDriver"
      vehicle: doc.vehicleId
      driver: doc.driverId
      seen: false
      timestamp: Date.now()
    alarm.alarmText = Alarms.alarmText (alarm)
    Alarms.insert alarm
