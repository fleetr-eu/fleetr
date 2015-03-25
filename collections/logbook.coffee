@Logbook = new Meteor.Collection "logbook"
@StartStop = new Meteor.Collection "startstop"

Logbook.after.insert (userId, e) ->
  # console.log 'HOOK!'
  # console.log JSON.stringify(e)
  id = e.deviceId

  Partitioner.directOperation ()->
    v = Vehicles.findOne {unitId: id}
    # console.log 'Vehicle: ' + v
    if not v
      console.log 'No vehicle found for unit id: ' + id
      return
    # console.log 'Vehicle: ' + JSON.stringify(v)
    if e.type == 30 # trackpoint
      update = {lastUpdate: e.recordTime, speed: e.speed, lat: e.lat, lon: e.lon, odometer: e.tacho}
      Vehicles.update v._id, {$set: update}
      console.log 'update vehile trackpoint status: ' + id + ' ' + JSON.stringify(update)
    if e.type == 29 # start/stop
      stop = e.io % 2 == 0
      status = if stop then 'stop' else 'start'
      speed = if stop then 0 else e.speed
      update = {lastUpdate: e.recordTime, speed: speed, lat: e.lat, lon: e.lon, odometer: e.tacho, state: status}
      Vehicles.update v._id, {$set: update}
      console.log 'update vehile start/stop status: ' + id + ' ' + JSON.stringify(update)

@StartStop.helpers
  #  startStop: ->
  #    start = moment(@start.recordTime).zone(Settings.unitTimezone).format('HH:mm:ss')
  #    stop = moment(@stop.recordTime).zone(Settings.unitTimezone).format('HH:mm:ss')
  #    twin(start,stop)
  #  fromTo: ->
  #     startLocation = geocode2(@start.type, @start.lat, @start.lon).split(',')[-3..]
  #     stopLocation = geocode2(@stop.type, @stop.lat, @stop.lon).split(',')[-3..]
  #     twin(startLocation, stopLocation)
  #  distanceOdometer: ->
  #    twin(@startStopDistance.toFixed(3), (@stop?.tacho/1000).toFixed(3))
  #  speedMaxSpeed:->
  #    twin(@startStopSpeed?.toFixed(2), @maxSpeed?.toFixed(2))
  #  duration: ->
  #    seconds = moment(@stop.recordTime).diff(moment(@start.recordTime), 'seconds')
  #    twin(moment.duration(seconds, "seconds").format('HH:mm:ss', {trim: false}), '')
  #  fuel: ->
  #    distance = (@stop.tacho-@start.tacho)/1000
  #    f = (@stop.fuelc-@start.fuelc)/1000
  #    twin(f.toFixed(2), (f/distance*100).toFixed(2))
  #  driverName: ->
  #    # vehicle = Vehicles.find ({unitId: obj.deviceId})
  #    # console.log 'Vehicle: ' + JSON.stringify(vehicle) if vehicle
  #    # driverId = Vehicles.getAssignedDriver(vehicle._id, Date.now())
  #    # console.log 'driverid: ' + driverId
  #    # driver = Drivers.findOne({_id: driverId})
  #    # console.log 'driver: ' + driver
  #    # console.log 'Driver: ' + JSON.stringify(driver) if driver
  #    twin('name','sirname')
