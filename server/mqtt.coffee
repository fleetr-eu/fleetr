Meteor.startup ->
  client = mqtt.connect 'mqtt://144.76.40.200'
  client.subscribe '/fleetr/records'
  client.on 'message', (topic, message) ->
    Fiber = Npm.require('fibers')
    data = message.toString()
    console.log 'MQTT: ' + data
    record = JSON.parse(data)
    Fiber(() -> 
      console.log 'inserting record...'	
      Logbook.insert record
    ).run()

  