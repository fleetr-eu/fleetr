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

class Geocoder
  constructor: (collection, name) ->
    @collection = collection
    @name = name
  process: ()->
    records = @collection.find({}).fetch()
    console.log 'Geocoding ' + @name + '(' + records.length +  ')...'
    for rec in records
      @processRecord(rec)
    console.log 'Geocoding ' + @name + ' done'

class StartStopGeocoder extends Geocoder
  constructor: () ->
    super StartStop, 'start/stop'
  processRecord: (rec)->
    return if rec.start.location and rec.stop.location
    startDate = moment(rec.start.recordTime).zone(UNIT_TIMEZONE).format("DD-MM HH:mm:ss") 
    stopDate  = moment(rec.stop.recordTime).zone(UNIT_TIMEZONE).format("DD-MM HH:mm:ss")
    console.log 'Geocode ' + @name + ' record: [' + startDate + "] - [" + stopDate + ']'
    startLocation = geocode(rec.start.lat, rec.start.lon)
    stopLocation = geocode(rec.stop.lat, rec.stop.lon)
    if startLocation and stopLocation
      StartStop.update {_id: rec._id}, {$set: {"stop.location": stopLocation, "start.location": startLocation}}
    else
      console.log @name + ' geocoding error'

class AggByDateGeocoder extends Geocoder
  constructor: () ->
    super AggByDate, 'aggbydate'
  processRecord: (rec)->
    return if rec.startLocation and rec.stopLocation
    first = StartStop.findOne {_id: rec.startId}
    last  = StartStop.findOne {_id: rec.stopId}
    if first and last
      startLocation = first.start.location
      stopLocation = last.stop.location
      AggByDate.update {_id: rec._id}, {$set: {"startLocation": startLocation, "stopLocation": stopLocation}}       
      console.log 'Geocode agg record: location updated'
    else
      console.log 'Geocode agg record: no startstop record found'

class IdleGeocoder extends Geocoder
  constructor: () ->
    super IdleBook, 'idlebook'
  processRecord: (rec)->
    return if rec.location
    console.log 'Geocode idle record...'
    location = geocode(rec.lat, rec.lon)
    if location
      IdleBook.update {_id: rec._id}, {$set: {"location": location}}       
      console.log '  idlebook: location updated'

upgradeDatabase = () ->
  new StartStopGeocoder().process()
  new AggByDateGeocoder().process()
  new IdleGeocoder().process()
  console.log 'DB UPGRADE DONE'

Meteor.startup ->
  Fiber = Npm.require('fibers')
  Fiber(upgradeDatabase).run()
