Meteor.startup ->
  client = mqtt.connect 'mqtt://localhost'
  client.subscribe 'presence'
  client.on 'message', (topic, message) ->
    console.log message.toString()
  client.publish 'presence', 'Hello mqtt'
  client.end()
