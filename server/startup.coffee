UNIT_TIMEZONE = '+0200'

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
      geo = new GeoCoder
        geocoderProvider: "openstreetmap"
        httpAdapter: "http"
      startLocation = geo.reverse(rec.start.lat, rec.start.lon)
      stopLocation = geo.reverse(rec.stop.lat, rec.stop.lon)
      if startLocation and stopLocation
        startLocation = startLocation[0]      
        stopLocation = stopLocation[0]
        
        startLocation.latitude  = rec.start.lat
        startLocation.longitude = rec.start.lon
        
        stopLocation.latitude  = rec.stop.lat
        stopLocation.longitude = rec.stop.lon
        
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
      # console.log '  first: ' + rec.startId + ' ' + first
      # console.log '  last : ' + rec.stopId + ' ' + last
      if first and last
        startLocation = first.start.location
        stopLocation = last.stop.location
        AggByDate.update {_id: rec._id}, {$set: {"startLocation": startLocation, "stopLocation": stopLocation}}       
        console.log '  agg: location updated'
      else
        console.log '  agg: no startstop record found'
  console.log 'Geocoding aggbydate done'

geocodeIdle = ->
  console.log 'Geocoding idlebook...'
  records = IdleBook.find({}).fetch()
  console.log 'Records(idlebook): ' + records.length
  for rec in records
    if rec.location
      # do nothins
    else
      geo = new GeoCoder
        geocoderProvider: "openstreetmap"
        httpAdapter: "http"
      console.log 'Geocode idle record...'
      location = geo.reverse(rec.lat, rec.lon)
      if location
        location = location[0]      
        location.latitude  = rec.lat
        location.longitude = rec.lon
        IdleBook.update {_id: rec._id}, {$set: {"location": location}}       
        console.log '  idlebook: location updated'
  console.log 'Geocoding aggbydate done'


upgradeDatabase = () ->
  geocodeStartStop()
  geocodeAggDyDate()
  geocodeIdle()
  console.log 'DB UPGRADE DONE'


Meteor.startup ->
  Fiber = Npm.require('fibers')
  Fiber(upgradeDatabase).run()

