@Logbook = new Meteor.Collection "logbook"

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

   