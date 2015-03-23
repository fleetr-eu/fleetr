# MQTT_URL = 'mqtt://144.76.40.200'
MQTT_URL = 'mqtt://gps.kale-bg.com:10013'


Meteor.startup ->
  client = mqtt.connect MQTT_URL
  client.subscribe '/fleetr/records'
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








 
  