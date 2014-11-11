@Locations = new Mongo.Collection 'locations'

Locations.before.insert (userId, doc) -> doc.timestamp ?= Date.now()

Locations.findForVehicles = (vehicleIds) ->
    Locations.find {vehicleId: {$in: vehicleIds}}, {sort: {timestamp: -1}}

Locations.log = ->
    if (navigator.geolocation)
      navigator.geolocation.getCurrentPosition(Locations.save)

Locations.getDistance = (lat1, lon1, lat2, lon2) ->
  R = 6371 # km
  f1 = lat1 * 0.0174532925
  f2 = lat2 * 0.0174532925
  df = (lat2 - lat1) * 0.0174532925
  dl = (lon2 - lon1) * 0.0174532925
  a = Math.sin(df / 2) * Math.sin(df / 2) + Math.cos(f1) * Math.cos(f2) * Math.sin(dl / 2) * Math.sin(dl / 2)
  c = 2 * Math.atan2(Math.sqrt(a), Math.sqrt(1 - a))
  R * c * 1000

Locations.getSpeed = (distance, timestamp1, timestamp2) ->
  time_s = (timestamp2 - timestamp1) / 1000.0
  speed_mps = distance / time_s
  console.log "#{distance} м / #{time_s} м/с= #{speed_mps * 3.6} км/ч"
  speed_mps * 3.6

Locations.saveToDatabase = (loc, speed, stay, distance, vehicleId )->
  Meteor.call 'addLocation',
    loc: loc
    speed: speed
    stay: stay
    distance: distance
    vehicleId: vehicleId

Locations.save = (pos)->
  if Session.get("loggedVehicle")
    newLocation = [pos.coords.longitude, pos.coords.latitude]
    lastLocation = Locations.findOne {vehicleId: Session.get("loggedVehicle")}, {sort: {timestamp: -1}}
    if lastLocation
      lastDistance = parseFloat(lastLocation.distance) || 0
      if (lastLocation.loc[0] != newLocation[0]) or (lastLocation.loc[1] != newLocation[1])
        distance = Locations.getDistance(lastLocation.loc[1], lastLocation.loc[0], newLocation[1], newLocation[0])
        speed = Locations.getSpeed(distance, lastLocation.timestamp, moment())
        Locations.saveToDatabase newLocation, speed, 0, lastDistance + distance, Session.get("loggedVehicle")
        console.log "move: speed = #{speed}"
      else
        stay = lastLocation.stay + Math.round(moment().diff(lastLocation.timestamp)/1000)
        Locations.saveToDatabase newLocation, 0, stay, lastLocation.distance, Session.get("loggedVehicle")
        console.log "stay: time=#{stay}"
    else
      Locations.saveToDatabase newLocation, 0, 0, 0, Session.get("loggedVehicle")
      console.log "start logging: "+Session.get("loggedVehicle")
