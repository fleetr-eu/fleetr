@Logbook    = new Meteor.Collection "logbook"
@StartStop  = new Meteor.Collection "startstop"
@AggByDate  = new Meteor.Collection "aggbydate"
@IdleBook   = new Meteor.Collection "idlebook"

Logbook.after.insert (userId, e) ->
  # console.log 'HOOK!'
  # console.log JSON.stringify(e)
  id = e.deviceId

  Partitioner.directOperation ->
    v = Vehicles.findOne {unitId: id}
    # console.log 'Vehicle: ' + v
    if not v
      console.log 'No vehicle found for unit id: ' + id
      return
    # console.log 'Vehicle: ' + JSON.stringify(v)
    if e.type == 30 # trackpoint
      if v.state == 'start'
        maxMeasuredSpeed = if e.speed > v.maxMeasuredSpeed then e.speed else v.maxMeasuredSpeed
        distance = e.tacho - v.odometer
        measuredDistance = v.measuredDistance + distance
        if distance < 5 then idleTime = v.idleTime + (e.recordTime - v.lastUpdate)
        tripTime = tripTime + (e.recordTime - v.lastUpdate)
        avgSpeed = (measuredDistance / 1000) / (tripTime / 1000 * 60 * 60)
        measuredFuel = v.measuredFuel + e.fuel
        restTime = 0
        update = {lastUpdate: e.recordTime, speed: e.speed, maxMeasuredSpeed: maxMeasuredSpeed, avgMeasuredSpeed: avgMeasuredSpeed, measuredDistance: measuredDistance, measuredFuel: measuredFuel, restTime: 0, idleTime: idleTime, lat: e.lat, lon: e.lon, odometer: e.tacho}
      else
        restTime = v.restTime + (e.recordTime - v.lastUpdate)
        update = {lastUpdate: e.recordTime, restTime: restTime }
      Vehicles.update v._id, {$set: update}, ->
        console.log 'updated vehicle trackpoint status: ' + id + ' ' + JSON.stringify(update)
    if e.type == 29 # start/stop
      stop = e.io % 2 == 0
      if stop
        status = 'stop'
        # ******** UPDATE current logbook record from Vehicle: add: maxMeasuredSpeed, avgMeasuredSpeed, v.measuredDistance, v.measuredFuel, v.restTime, v.idleTime
      else
        status = 'start'
      update = {lastUpdate: e.recordTime, speed: 0, maxMeasuredSpeed: 0, avgMeasuredSpeed: 0, measuredDistance: 0, measuredFuel: 0, restTime: 0, idleTime: 0, lat: e.lat, lon: e.lon, odometer: e.tacho, state: status}
      Vehicles.update v._id, {$set: update}, ->
        console.log 'updated vehicle start/stop status: ' + id + ' ' + JSON.stringify(update)

@AggByDate.helpers
  general: ->
    @date + ' (' + @total + ')'
  fromTo: ->
    start = moment(@startTime).zone(Settings.unitTimezone).format('HH:mm:ss')
    stop = moment(@stopTime).zone(Settings.unitTimezone).format('HH:mm:ss')
    twin(start,stop)
  beginEnd: ->
    startLocation = if @startLocation then toAddress(@startLocation) else 'not geocoded yet...'
    stopLocation  = if @stopLocation then toAddress(@stopLocation) else 'not geocoded yet...'
    # startLocation = geocode2(29, @startLat, @startLon).split(',')[-3..]
    # stopLocation = geocode2(29, @stopLat, @stopLon).split(',')[-3..]
    twin(startLocation, stopLocation)
  interval: ->
    travel = moment.duration(@sumInterval, "seconds").format('HH:mm:ss', {trim: false})
    idle = moment.duration(@idleTime, "seconds").format('HH:mm:ss', {trim: false})
    twin(travel,idle)
  distance: ->
    @sumDistance?.toFixed(2)
  speed: ->
    twin(@avgSpeed?.toFixed(0),@maxSpeed?.toFixed(0))
  fuel: ->
    distance = @sumDistance
    f = @sumFuel/1000
    twin(f.toFixed(2), (f/distance*100).toFixed(2))

twin = (str1,str2) ->
  new Spacebars.SafeString(str1 + '<br>' + str2)

MESSAGE_ROW_TYPE  = 0
START_STOP_ROW_TYPE  = 29
REGULAR_ROW_TYPE  = 30
EVENT_ROW_TYPE    = 35
LANGUAGE = 'bg'

toAddress = (loc)->
  return 'not geocoded yet...' if not loc
  addr = loc.country
  addr += ', ' + loc.city
  addr += ', ' + loc.zipcode if loc.zipcode
  addr += ', ' + loc.streetName

@StartStop.helpers
   startStop: ->
     # console.log 'this: ' + JSON.stringify(this)
     start = moment(@start.recordTime).zone(Settings.unitTimezone).format('HH:mm:ss')
     stop = moment(@stop.recordTime).zone(Settings.unitTimezone).format('HH:mm:ss')
     twin(start,stop)
   fromTo: ->
      startLocation = if @start.location then toAddress(@start.location) else 'not geocoded yet...'
      stopLocation  = if @stop.location then toAddress(@stop.location) else 'not geocoded yet...'
      # startLocation = geocode2(@start.type, @start.lat, @start.lon).split(',')[-3..]
      # stopLocation = geocode2(@stop.type, @stop.lat, @stop.lon).split(',')[-3..]
      twin(startLocation, stopLocation)
   distanceOdometer: ->
     twin(@startStopDistance.toFixed(3), (@stop?.tacho/1000).toFixed(3))
   speedMaxSpeed:->
     twin(@startStopSpeed?.toFixed(2), @maxSpeed?.toFixed(2))
   duration: ->
     seconds = moment(@stop.recordTime).diff(moment(@start.recordTime), 'seconds')
     twin(moment.duration(seconds, "seconds").format('HH:mm:ss', {trim: false}), '')
   fuel: ->
     distance = (@stop.tacho-@start.tacho)/1000
     f = (@stop.fuelc-@start.fuelc)/1000
     twin(f.toFixed(2), (f/distance*100).toFixed(2))
   driverName: ->
     driver = Vehicles.getAssignedDriverByUnitId @start.deviceId, @start.recordTime
     if driver then twin(driver.firstName, driver.name) else twin('unknown','')

@IdleBook.helpers
  idledate: -> moment(@startTime).zone(Settings.unitTimezone).format('DD-MM-YYYY')
  from    : -> moment(@startTime).zone(Settings.unitTimezone).format('HH:mm:ss')
  to      : -> moment(@stopTime).zone(Settings.unitTimezone).format('HH:mm:ss')
  dur     : -> moment.duration(@duration, "seconds").format('HH:mm:ss', {trim: false})
  address : -> toAddress(@location)
  passedDistance: -> @distance #.toFixed(0)
  driverName: ->
    driver = Vehicles.getAssignedDriverByUnitId @deviceId, @startTime
    if driver then twin(driver.firstName + '&nbsp;' + driver.name, '') else twin('unknown','')
