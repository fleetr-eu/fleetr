Meteor.startup ->
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
        console.log '  convert date: ' + date
        record.recordTime = date
      console.log 'inserting record: ' + JSON.stringify(record)
      Logbook.insert record
    ).run()
