Fiber = Npm.require('fibers')

Meteor.startup ->
  opts = if Meteor.settings.mqttUrl
    {}
  else
    clientId: 'fleetr_eu'
  mqttUrl = Meteor.settings.mqttUrl || 'mqtt://mqtt:1883'
  console.log "MQTT: URL #{mqttUrl}, options #{EJSON.stringify opts}"
  client = mqtt.connect mqttUrl, opts

  client.on 'error', (err) ->
    console.error 'MQTT: Could not connect to server!', err

  client.on 'connect', ->
    console.log 'MQTT CONNECTED OK'
    #subscribe at QoS level 2
    client.subscribe '/fleetr/records': 2, (err, granted) ->
      if err
        console.log "MQTT Error: #{err}"
      else
        console.log 'MQTT SUBSCRIBED: ' + JSON.stringify(granted)

  client.on 'disconnect', -> console.log '*** MQTT DISCONNECTED'

  client.on 'message', (_topic, msg) ->
    isStart = (r) -> r.type is 29 and r.io is 255
    isStop = (r) -> r.type is 29 and r.io is 254
    isTracking = (r) -> r.type is 30

    record = EJSON.parse msg.toString()
    console.log "MQTT: Message received, #{EJSON.stringify record}"
    Fiber(-> LogbookProcessor.insertRecord(record)).run()

    Fiber(->
      if isStart(record)
        TripProcessor.deviceStart record
      else if isStop(record)
        TripProcessor.deviceStop record
      else if isTracking(record)
        TripProcessor.deviceMove record
      else
        console.warn "MQTT: Unhandled record type #{record.type}."
    ).run()
