UNIT_TIMEZONE = '+0200'

geocoder = new GeoCoder
  geocoderProvider: "openstreetmap"
  httpAdapter: "http"

@geocode = (lat,lon) ->
  location = geocoder.reverse(lat, lon)
  if location 
    location = location[0]      
    location.latitude  = lat
    location.longitude = lon
  return location      

geocodeStartStop = ->
  console.log 'Geocoding start/stop...'
  records = StartStop.find({}).fetch()
  console.log 'Records(start/stop): ' + records.length
  for rec in records
    # if false and rec.start.location and rec.stop.location
    if rec.start.location and rec.stop.location
      # do nothins
      # console.log 'start.location: ' + JSON.stringify(rec.start.location)
      # console.log 'stop.location : ' + JSON.stringify(rec.stop.location)
    else
      startDate = moment(rec.start.recordTime).zone(UNIT_TIMEZONE).format("DD-MM HH:mm:ss") 
      stopDate  = moment(rec.stop.recordTime).zone(UNIT_TIMEZONE).format("DD-MM HH:mm:ss")
      console.log 'Geocode start/stop record: [' + startDate + "] - [" + stopDate + ']'
      # console.log 'Processing start/stop record...'

      # console.log 'start.loc: ' + rec.start.location
      # console.log 'stop.loc : ' + rec.stop.location
      startLocation = geocode(rec.start.lat, rec.start.lon)
      stopLocation = geocode(rec.stop.lat, rec.stop.lon)
      if startLocation and stopLocation
        StartStop.update {_id: rec._id}, {$set: {"stop.location": stopLocation, "start.location": startLocation}}
      else
        console.log 'geocoding error'
  console.log 'Geocoding start/stop done'


geocodeAggDyDate = ->
  console.log 'Geocoding aggbydate...'
  records = AggByDate.find({}).fetch()
  console.log 'Records(aggbydate): ' + records.length
  for rec in records
    # if false and rec.start.location and rec.stop.location
    if rec.startLocation and rec.stopLocation
      # do nothins
      # console.log 'start.location: ' + JSON.stringify(rec.start.location)
      # console.log 'stop.location : ' + JSON.stringify(rec.stop.location)
    else
      
      console.log 'Geocode agg record...'
      first = StartStop.findOne {_id: rec.startId}
      last  = StartStop.findOne {_id: rec.stopId}
      console.log '  first: ' + rec.startId + ' ' + first
      console.log '  last : ' + rec.stopId + ' ' + last
      if first and last
        startLocation = first.start.location
        stopLocation = last.stop.location
        AggByDate.update {_id: rec._id}, {$set: {"startLocation": startLocation, "stopLocation": stopLocation}}       
        console.log '  agg: location updated'
      else
        console.log '  agg: no startstop record found'
  console.log 'Geocoding aggbydate done'


upgradeDatabase = () ->
  geocodeStartStop()
  
  # fix stop values in aggregation...
  geocodeAggDyDate()

  console.log 'DB UPGRADE DONE'


Meteor.startup ->
  Fiber = Npm.require('fibers')
  Fiber(upgradeDatabase).run()

