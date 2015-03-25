UNIT_TIMEZONE = '+0200'

makeStartStopRecord = (start,stop)->
  record = {start: start, stop: stop}
  # record = {}

  distance = (stop.tacho-start.tacho)/1000
  record.fuelUsed = stop.fuelc - start.fuelc
  seconds = moment(stop.recordTime).diff(moment(start.recordTime), 'seconds')

  record.startStopDistance = distance
  record.startStopSpeed =  (distance*3600/seconds)


  withMaxSpeed = Logbook.findOne {type:30, recordTime: {$gte: start.recordTime, $lte: stop.recordTime}}, {sort: {speed:-1}}
  maxSpeed = withMaxSpeed.speed if withMaxSpeed
  # maxSpeed = record.startStopSpeed if not maxSpeed
  record.maxSpeed = maxSpeed

  record.interval = (stop.recordTime.getTime() - start.recordTime.getTime())/1000

  record.recordTime = start.recordTime
  record.date = moment(stop.recordTime).zone(UNIT_TIMEZONE).format('YYYY-MM-DD')
  console.log 'start/stop record: ' + JSON.stringify(record)
  return record

updateAggRecord = (record) ->
  agg = AggByDate.findOne {date: record.date}
  if not agg
    agg =
      date        : record.date
      startLat    : record.start.lat
      stopLat     : record.stop.lat
      startLon    : record.start.lon
      stopLon     : record.stop.lon
      startTime   : record.start.recordTime
      stopTime    : record.stop.recordTime
      stopOdo     : record.stop.tacho
      sumDistance : record.startStopDistance
      sumFuel     : record.fuelUsed
      sumInterval : record.interval
      avgSpeed    : record.startStopSpeed
      maxSpeed    : record.maxSpeed
      total       : 1
    console.log 'Insert: ' + agg.date + ' dis: ' + agg.sumDistance
    AggByDate.insert agg
  else
    agg.sumDistance += record.startStopDistance
    agg.sumFuel     += record.fuelUsed
    agg.sumInterval += record.interval
    agg.avgSpeed     = agg.sumDistance/agg.sumInterval*3600;
    agg.maxSpeed     = record.maxSpeed if record.maxSpeed > agg.maxSpeed
    agg.total++
    console.log 'Updated: ' + agg.date + ' dis: ' + agg.sumDistance + ' avg: ' + agg.avgSpeed + ' max: ' + agg.maxSpeed
    update =
      sumDistance : agg.sumDistance
      sumFuel     : agg.sumFuel
      sumInterval : agg.sumInterval
      avgSpeed    : agg.avgSpeed
      maxSpeed    : agg.maxSpeed
      total       : agg.total
    AggByDate.update {_id: agg._id}, {$set: update}
    return agg

process = (r)->
  # console.log 'Processing!'
  lastStart = Logbook.findOne {type:29,io:255}, {sort: {recordTime:-1}}
  console.log 'LastStart: ' + JSON.stringify(lastStart)
  console.log 'LastStart: ' + moment(lastStart.recordTime).zone(UNIT_TIMEZONE).format('YYYY-MM-DD HH:mm:ss') + ' io: ' + lastStart.io + ' tacho: ' + lastStart.tacho + ' fuel: ' + lastStart.fuelc
  console.log 'ThisStop : ' + moment(r.recordTime).zone(UNIT_TIMEZONE).format('YYYY-MM-DD HH:mm:ss') + ' io: ' + r.io + ' tacho: ' + r.tacho + ' fuel: ' + r.fuelc

  start = lastStart
  stop = r

  record = makeStartStopRecord(start,stop)
  StartStop.insert record
  updateAggRecord record

Meteor.startup ->
  console.log 'MQTT URL: ' + Meteor.settings.mqttUrl
  client = mqtt.connect Meteor.settings.mqttUrl || 'mqtt://mqtt:1883'
  client.subscribe '/fleetr/records': 2, (err, granted) -> #subscribe at QoS level 2
    console.log "MQTT Error: #{err}" if err

  client.on 'message', (topic, message) ->
    Fiber = Npm.require('fibers')
    data = message.toString()
    console.log 'MQTT: ' + data
    record = JSON.parse(data)
    Fiber(() ->
      #if typeof record.recordTime is 'string'
      #  date = new Date(record.recordTime)
      #  console.log '  date: ' + date + ' ' + (typeof date)
      if typeof record.recordTime is 'string'
        date = new Date(record.recordTime)
        # console.log '  convert date: ' + date
        record.recordTime = date
      # console.log 'inserting record: ' + JSON.stringify(record)
      if record.type == 29 and record.io == 254
        process(record)
      Logbook.insert record
    ).run()
