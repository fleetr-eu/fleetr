Meteor.startup ->
  Partitioner.directOperation ->
    Geofences.find().forEach (gf) ->
      cursor = Vehicles.find
        _groupId: gf._groupId
        state: 'stop'
        loc:
          $geoWithin:
            $centerSphere: [ gf.center, gf.radius / 6378100 ]
        # "rest.duration":
        #   $gt: 1 

      cursor.observe
        added: (doc) ->
          console.log '++++++++++++++++++++++++++++++++++++++++++++++++++++'
          console.log "Vehicle #{doc.name} entered #{gf.name}!"
          Partitioner.bindGroup doc._groupId, ->
            Alarms.insert
              type: 'enterGeofence'
              geofenceId: gf._id
              vehicleId: doc._id
        removed: (doc) ->
          console.log '----------------------------------------------------'
          console.log "Vehicle #{doc.name} left #{gf.name}!"
          Partitioner.bindGroup doc._groupId, ->
            Alarms.insert
              type: 'leaveGeofence'
              geofenceId: gf._id
              vehicleId: doc._id
