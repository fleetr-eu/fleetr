@Alarms = new Mongo.Collection 'alarms'

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
    filter['$or'] = [{tags: rx}]
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
  if doc.speed > 100
    Alarms.insert
      type: "overspeeding"
      vehicle: doc.vehicleId
      speed: doc.speed
      loc: doc.loc
      seen: false
      timestamp: Date.now()

  if doc.stay > 60
    Alarms.insert
      type: "longStay"
      vehicle: doc.vehicleId
      stay: doc.stay
      loc: doc.loc
      seen: false
      timestamp: Date.now()

  dvAssignment = DriverVehicleAssignments.findOne(
    vehicle: doc.vehicleId
    beginAssignmentTime:
      $lte: new Date(doc.timestamp)
    endAssignmentTime:
      $gte: new Date(doc.timestamp)
  )

  if (doc.speed > 0) and !dvAssignment
    alarm = Alarms.findOne {type: "unasignedDriver", vehicle: doc.vehicleId}, {sort: {timestamp: -1}}
    if alarm and Date.now() < moment(alarm.timestamp).add(1, 'minutes').toDate()

    else
      Alarms.insert
        type: "unasignedDriver"
        vehicle: doc.vehicleId
        seen: false
        timestamp: Date.now()
