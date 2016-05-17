Fiber = Npm.require('fibers')

Meteor.startup ->
  opts = if Meteor.settings.mqttUrl
    if Meteor.settings.mqttClientId
      clientId: Meteor.settings.mqttClientId
    else
      {}
  else
    clientId: Meteor.settings.mqttClientId or 'fleetr_eu'
  mqttUrl = Meteor.settings.mqttUrl || 'mqtt://mqtt:1883'

  console.log "MQTT: URL #{mqttUrl}, options #{EJSON.stringify opts}"
  client = mqtt.connect mqttUrl, opts

  client.on 'error', (err) ->
    console.error 'MQTT: Could not connect to server!', err

  client.on 'connect', ->
    console.log 'MQTT CONNECTED OK'
    #subscribe at QoS level 1
    client.subscribe '/fleetr/traccar-records': 1, (err, granted) ->
      if err
        console.log "MQTT ERROR: #{err}"
      else
        console.log 'MQTT SUBSCRIBED: ' + JSON.stringify(granted)

  client.on 'disconnect', -> console.log '*** MQTT DISCONNECTED'


  client.on 'message', (_topic, msg) ->
    record = EJSON.parse msg.toString()
    console.log "MQTT: MESSAGE RECEIVED ON TOPIC #{_topic}: #{EJSON.stringify record}"

    if _topic is '/fleetr/traccar-records'
      Fiber(-> TraccarLogbookProcessor.insertRecord(record)).run()
    else
      isEven = (n) -> (n % 2) is 0
      isOdd = (n) -> not isEven(n)

      isStart = (r) -> r.type is 29 and isOdd(r.io)
      isStop = (r) -> r.type is 29 and isEven(r.io)
      isTracking = (r) -> r.type is 30
      isPing = (r) -> r.type is 0

      Fiber(-> LogbookProcessor.insertRecord(record)).run()

      Fiber(->
        if isTracking(record)
          TripProcessor.deviceMove record
        else if isStart(record)
          TripProcessor.deviceStart record
        else if isStop(record)
          TripProcessor.deviceStop record
        else if isPing(record)
          EventProcessor.devicePing record
        else
          console.warn "MQTT: Unhandled record type #{record.type}."
      ).run()

  Meteor.methods
    replayLogbook: (dt) ->
      console.log "Resending events from #{dt}."
      date = if dt then new Date(dt) else new Date()
      Partitioner.directOperation ->
        Logbook.find({recordTime: $gt: date}, {sort: recordTime: 1}).forEach (l) ->
          i = 0
          pub = ->
            client.publish '/fleetr/records', _.omit(l, '_id')
            i++
          Meteor.setTimeout pub, i*50
