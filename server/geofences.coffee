Meteor.startup ->
  Meteor.setInterval findLocationsInGeofence, 60000

findLocationsInGeofence = =>
  @unblock
  Geofences.find().map (gf) ->
    Locations.find
      loc:
        $geoWithin:
          $center: [ gf.center, gf.radius ]
      timestamp:
        $gte: Date.now() - 60000
    .forEach (l) ->
      # l is a location created in the last minute that is within a geofence gf
      # add a notification or something
      console.log l
