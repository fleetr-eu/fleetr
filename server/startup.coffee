
upgradeDatabase = () ->
  # records = StartStop.find({}, {limit:1}).fetch()
  records = StartStop.find({}).fetch()
  console.log 'Records: ' + records.length
  for rec in records
    # if false and rec.start.location and rec.stop.location
    if rec.start.location and rec.stop.location
      # do nothins
      # console.log 'start.location: ' + JSON.stringify(rec.start.location)
      # console.log 'stop.location : ' + JSON.stringify(rec.stop.location)
    else
      console.log 'Processing record...'
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
  console.log 'DONE'


Meteor.startup ->
  Fiber = Npm.require('fibers')
  Fiber(upgradeDatabase).run()






