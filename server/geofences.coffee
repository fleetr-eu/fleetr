observers =
  gfe: {}
  gf: {}

Meteor.startup ->
  Partitioner.directOperation ->
    GeofenceEvents.find().observe
      added: (gfe) ->
        observers.gfe[gfe._id] = createGfObserver gfe
      removed: (gfe) ->
        observers.gfe[gfe._id].stop()
        delete observers.gfe[gfe._id]
      changed: (gfe) ->
        observers.gfe[gfe._id].stop()
        observers.gfe[gfe._id] = createGfObserver gfe

createGfObserver = (gfe) ->
  createVehicleObserver = (gf) ->
    vehiclesCursor =
      Partitioner.bindGroup gf._groupId, ->
        Vehicles.find
          _id: gfe.vehicleId
          loc:
            $geoWithin:
              $centerSphere: [ gf.center, gf.radius / 6378100 ]
        ,
          fields:
            name: 1

    vehiclesCursor.observe
      added: (v) -> addAlarm 'geofence:enter', gf, v if gfe.enter
      removed: (v) -> addAlarm 'geofence:exit', gf, v if gfe.exit

  Geofences.find({_id: gfe.geofenceId}, {fields: tags: 0}).observe
    added: (gf) ->
      observers.gf[gf._id] = createVehicleObserver gf
    removed: (gf) ->
      observers.gf[gf._id].stop()
      delete observers.gf[gf._id]
    changed: (gf) ->
      observers.gf[gf._id].stop()
      observers.gf[gf._id] = createVehicleObserver gf

addAlarm = (type, gf, v) ->
  console.log """
    Event '#{type}' occurred:
    vehicle '#{v.name}', geofence '#{gf.name}'"""
  Partitioner.bindGroup gf._groupId, ->
    Alarms.insert
      type: type
      time: new Date()
      geofenceId: gf._id
      vehicleId: v._id
