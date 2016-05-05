Meteor.publish 'logbook/trip', (tripId) ->
  if tripId
    Logbook.find {'attributes.trip': tripId}, {sort: {recordTime: 1}}
  else
    []
