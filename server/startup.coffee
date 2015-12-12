###geocoder = new GeoCoder
  geocoderProvider: "openstreetmap"
  httpAdapter: "http"
###

@geocode = (lat,lon) ->
  ###console.log '  geocoding: ' + lat + ' : ' + lon
  return undefined if not lat and not lon
  try
    # FIX: figure out the reverse geocoding
    # location = geocoder.reverse(lat, lon)
  catch err
    console.log '  geocode err: ' + err
  console.log '  geocoded location: ' + JSON.stringify(location)
  if location
    # console.log '  geocoded location: ' + JSON.stringify(location)
    location = location[0]
    location.latitude  = lat
    location.longitude = lon
  return location
  ###
  "a string"

class RecordProcessor
  constructor: (collection, name) ->
    @collection = collection
    @name = name
  process: ()->
    records = @collection.find({}).fetch()
    console.log 'Processing ' + @name + '(' + records.length +  ')...'
    for rec in records
      @processRecord(rec)
    console.log 'Processing ' + @name + ' done'


class Geocoder extends RecordProcessor
  constructor: (collection, name) ->
    super collection, name
  # process: ()->
  #   records = @collection.find({}).fetch()
  #   console.log 'Geocoding ' + @name + '(' + records.length +  ')...'
  #   for rec in records
  #     @processRecord(rec)
  #   console.log 'Geocoding ' + @name + ' done'
  toAddress: (loc)->
    return undefined if not loc
    addr = loc.country
    addr += ', ' + loc.city
    addr += ', ' + loc.zipcode if loc.zipcode
    addr += ', ' + loc.streetName


class StartStopGeocoder extends Geocoder
  constructor: () ->
    super StartStop, 'start/stop'
  processRecord: (rec)->
    return if rec.startAddress and rec.stopAddress
    if not rec.start.location or not rec.stop.location
      startDate = moment(rec.start.recordTime).zone(Settings.unitTimezone).format("DD-MM HH:mm:ss")
      stopDate  = moment(rec.stop.recordTime).zone(Settings.unitTimezone).format("DD-MM HH:mm:ss")
      console.log 'Geocode ' + @name + ' record: [' + startDate + "] - [" + stopDate + ']'

      startLocation = geocode(rec.start.lat, rec.start.lon) if not rec.startAddress
      if startLocation
        StartStop.update {_id: rec._id}, {$set: {"start.location": startLocation}}
        console.log '  ' + @name + ' start location geocoded'
      else
        console.log '  ' + @name + ' couldn not geocode start location'
      # console.log 'START LOC: ' + JSON.stringify(rec.start) if not startLocation

      stopLocation = geocode(rec.stop.lat, rec.stop.lon) if not rec.stopAddress
      # console.log 'STOP LOC: ' + JSON.stringify(rec.stop) if not stopLocation
      if stopLocation
        StartStop.update {_id: rec._id}, {$set: {"stop.location": stopLocation}}
        console.log '  ' + @name + ' stop  location geocoded'
      else
        console.log '  ' + @name + ' couldn not geocode stop location'

      #if startLocation and stopLocation
      #  StartStop.update {_id: rec._id}, {$set: {"stop.location": stopLocation, "start.location": startLocation}}
      #else
      #  console.log '  ' + @name + ' geocoding error'
    # console.log 'recording start/stop address'
    rec.startAddress = @toAddress(rec.start.location) if rec.start.location
    rec.stopAddress  = @toAddress(rec.stop.location) if rec.stop.location
    StartStop.update {_id: rec._id}, {$set: {"startAddress": rec.startAddress, "stopAddress": rec.stopAddress}}

class AggByDateGeocoder extends Geocoder
  constructor: () ->
    super AggByDate, 'aggbydate'
  processRecord: (rec)->
    return if rec.startAddress and rec.stopAddress
    if not rec.startLocation or not rec.stopLocation
      first = StartStop.findOne {_id: rec.startId}
      last  = StartStop.findOne {_id: rec.stopId}
      if first and last
        startLocation = first.start.location
        stopLocation = last.stop.location
        AggByDate.update {_id: rec._id}, {$set: {"startLocation": startLocation, "stopLocation": stopLocation}}
        console.log 'Geocode agg record: location updated'
      else
        console.log 'Geocode agg record: no startstop record found'
    rec.startAddress = @toAddress(rec.startLocation) if rec.startLocation
    rec.stopAddress  = @toAddress(rec.stopLocation) if rec.stopLocation
    AggByDate.update {_id: rec._id}, {$set: {"startAddress": rec.startAddress, "stopAddress": rec.stopAddress}}
    console.log 'agg record: start/stop address updated'


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

class LogbookEnhancer extends RecordProcessor
  constructor: () ->
    super Logbook, 'logbook'
  processRecord: (rec)->
    if not rec.loc
      loc = [rec.lon, rec.lat]
      Logbook.update {_id: rec._id}, {$set: {loc: loc}}

# upgradeDatabase = () ->
#   console.log 'ENHANCE DB'
#   new LogbookEnhancer().process()
#   new StartStopGeocoder().process()
#   new AggByDateGeocoder().process()
#   new IdleGeocoder().process()
#   console.log 'DB UPGRADE DONE'
#
# Meteor.startup ->
#   Fiber = Npm.require('fibers')
#   Fiber(upgradeDatabase).run()
