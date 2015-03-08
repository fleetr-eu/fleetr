Meteor.startup ->
  client = mqtt.connect 'mqtt://144.76.40.200'
  client.subscribe 'xxx'
  client.on 'message', (topic, message) ->
    console.log 'MQTT: ' + message.toString()
  