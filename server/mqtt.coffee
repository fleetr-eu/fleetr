UNIT_TIMEZONE = '+0200'

makeStartStopRecord = (start,stop)->
  console.log 'Process STOP record'
  record = {start: start, stop: stop}

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

  startLocation = geocode(record.start.lat, record.start.lon)
  stopLocation = geocode(record.stop.lat, record.stop.lon)
  if startLocation and stopLocation
    record.start.location = startLocation    
    record.stop.location = stopLocation    

  console.log 'start/stop record: ' + JSON.stringify(record)
  return record

updateAggRecord = (record) ->
  agg = AggByDate.findOne {date: record.date}
  if not agg
    agg = 
      date        : record.date
      startId     : record._id
      startTime   : record.start.recordTime
      sumDistance : record.startStopDistance     
      startLocation: record.start.location
      sumFuel     : record.fuelUsed
      sumInterval : record.interval
      avgSpeed    : record.startStopSpeed
      maxSpeed    : record.maxSpeed
      total       : 1
      stopId      : record._id
      stopTime    : record.stop.recordTime
      stopOdo     : record.stop.tacho
      stopLocation: record.stop.location
    console.log 'Insert: ' + agg.date + ' dis: ' + agg.sumDistance
    AggByDate.insert agg
  else
    agg.sumDistance += record.startStopDistance     
    agg.sumFuel     += record.fuelUsed
    agg.sumInterval += record.interval
    agg.avgSpeed     = agg.sumDistance/agg.sumInterval*3600;
    agg.maxSpeed     = record.maxSpeed if record.maxSpeed > agg.maxSpeed
    agg.stopTime     = record.stop.recordTime
    agg.stopOdo      = record.stop.tacho
    agg.stopId       = record._id
    agg.stopLocation = record.stop.location
    agg.total++
    console.log 'Updated: ' + agg.date + ' dis: ' + agg.sumDistance + ' avg: ' + agg.avgSpeed + ' max: ' + agg.maxSpeed 
    update = 
      sumDistance : agg.sumDistance
      sumFuel     : agg.sumFuel
      sumInterval : agg.sumInterval
      avgSpeed    : agg.avgSpeed
      maxSpeed    : agg.maxSpeed
      total       : agg.total
      stopTime    : agg.stopTime
      stopOdo     : agg.stopOdo
      stopId      : agg.stopId 
      stopLocation: agg.stopLocation 
    AggByDate.update {_id: agg._id}, {$set: update}
    return agg


prepareLogbookRecord = (record)->
  record.loc = [record.lon, record.lat]

processStopRecord = (r)->
  # console.log 'Processing!'
  lastStart = Logbook.findOne {type:29,io:255}, {sort: {recordTime:-1}}
  # console.log 'LastStart: ' + JSON.stringify(lastStart)
  # console.log 'LastStart: ' + moment(lastStart.recordTime).zone(UNIT_TIMEZONE).format('YYYY-MM-DD HH:mm:ss') + ' io: ' + lastStart.io + ' tacho: ' + lastStart.tacho + ' fuel: ' + lastStart.fuelc
  # console.log 'ThisStop : ' + moment(r.recordTime).zone(UNIT_TIMEZONE).format('YYYY-MM-DD HH:mm:ss') + ' io: ' + r.io + ' tacho: ' + r.tacho + ' fuel: ' + r.fuelc

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

  idleDetector = new IdleDetector

  client.on 'message', (topic, message) ->
    Fiber = Npm.require('fibers')
    data = message.toString()
    console.log 'MQTT: ' + data
    # console.log 'Geocoder: ' + geocoder
    record = JSON.parse(data)
    Fiber(() ->
      #if typeof record.recordTime is 'string'
      #  date = new Date(record.recordTime)
      #  console.log '  date: ' + date + ' ' + (typeof date)
      if typeof record.recordTime is 'string'
        date = new Date(record.recordTime)
        # console.log '  convert date: ' + date
        record.recordTime = date
      prepareLogbookRecord(record)
      if record.type == 29 and record.io == 254
        processStopRecord(record)
      Logbook.insert record

      idle = idleDetector.process(record)
      if idle
        IdleBook.insert idle if idle
        console.log 'New idle interval inserted'

    ).run()
