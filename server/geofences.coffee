Meteor.startup ->
  Partitioner.directOperation ->
    console.log 'registering geofences'
    geofences = Geofences.find()
    geofences.forEach (gf) ->
      vehicles = Vehicles.find
        _groupId: gf._groupId
        state: 'stop'
        loc:
          $geoWithin:
            $centerSphere: [ gf.center, gf.radius / 6378100 ]
        # "rest.duration":
        #   $gt: 1

      addAlarm = (type, v) ->
        Partitioner.bindGroup gf._groupId, ->
          Alarms.insert
            type: 'leaveGeofence'
            time: new Date()
            geofenceId: gf._id
            vehicleId: v._id

      vehicles.observe
        added: (doc) ->
          console.log '++++++++++++++++++++++++++++++++++++++++++++++++++++'
          console.log "Vehicle #{doc.name} entered #{gf.name}!"
          addAlarm 'enterGeofence', doc
        removed: (doc) ->
          console.log '----------------------------------------------------'
          console.log "Vehicle #{doc.name} left #{gf.name}!"
          addAlarm 'leaveGeofence', doc
