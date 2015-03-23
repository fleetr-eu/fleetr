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


Meteor.startup ->
  console.log 'MQTT URL: ' + Meteor.settings.mqttUrl
  client = mqtt.connect Meteor.settings.mqttUrl || 'mqtt://mqtt'

  client.subscribe '/fleetr/records': 2, (err, granted) ->
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
