Meteor.startup ->
  Partitioner.directOperation ->
    Geofences.find().forEach (gf) ->
      cursor = Vehicles.find
        loc:
          $geoWithin:
            $center: [ gf.center, gf.radius ]
        "rest.duration":
          $gt: moment.duration(20, 'minutes')

      cursor.observe
        added: (doc) ->
          console.log "Vehicle #{v.name} stayed over limit in #{gf.name}!"
