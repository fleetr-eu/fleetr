gfi = null
Accounts.onLogin (opts) ->
  gfi = Meteor.setInterval findLocationsInGeofence, 60000

findLocationsInGeofence = =>
  @unblock
  user = Meteor.call 'getUser'
  if user
    Geofences.find(_groupId: user.group).map (gf) ->
      Locations.find
        loc:
          $geoWithin:
            $center: [ gf.center, gf.radius ]
        timestamp:
          $gte: Date.now() - 60000
      .forEach (loc) ->
        if loc.stay
          vehicle = Vehicles.findOne _id: loc.vehicleId
          Alarms.insert
            type: "arrival"
            vehicle: loc.vehicleId
            timestamp: loc.timestamp
            alarmText: "Автомобил с регистрационен номер #{vehicle.licensePlate} пристигна на обект #{gf.name}."
            seen: false
  else
    Meteor.clearInterval(gfi) if gfi
