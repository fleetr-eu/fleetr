observers =
  gfe: {}
  gf: {}

Meteor.startup ->
  Partitioner.directOperation ->
    gfeCursor = GeofenceEvents.find
      active: true
    ,
      fields:
        active: 1
        geofenceId: 1
        vehicleId: 1
        enter: 1
        exit: 1

    gfeCursor.observe
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

    addAlarm = (type, v) ->
      console.log """
        Event '#{type}' occurred (geofence event id #{gfe._id}):
        vehicle id '#{v._id}', geofence id '#{gf._id}'"""
      Partitioner.bindGroup gf._groupId, ->
        Alarms.add
          type: type
          data:
            geofenceEventId: gfe._id
            geofenceId: gf._id
            vehicleId: v._id

    vehiclesCursor = Partitioner.bindGroup gf._groupId, -> Vehicles.find
      _id: gfe.vehicleId
      lastUpdate: $gte: new Date()
      loc:
        $geoWithin:
          $centerSphere: [ gf.center, gf.radius / 6378100 ]
    ,
      fields:
        _id: 1

    vehiclesCursor.observe
      added: (v) -> addAlarm 'geofence.enter', v if gfe.enter
      removed: (v) -> addAlarm 'geofence.exit', v if gfe.exit

  gfCursor = Geofences.find
    _id: gfe.geofenceId
  ,
    fields:
      name: 0
      tags: 0

  gfCursor.observe
    added: (gf) ->
      observers.gf[gf._id] = createVehicleObserver gf
    removed: (gf) ->
      observers.gf[gf._id].stop()
      delete observers.gf[gf._id]
    changed: (gf) ->
      observers.gf[gf._id].stop()
      observers.gf[gf._id] = createVehicleObserver gf
