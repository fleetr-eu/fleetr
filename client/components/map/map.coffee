Template.fleetrMap.onCreated ->
  @showGeofences = new ReactiveVar false

Template.fleetrMap.onRendered ->
  console.log @
  @map = new FleetrMap '#map-canvas',
    showVehicles: @data.showVehicles

  @autorun =>
    if @selectedVehicle?._id isnt Session.get('selectedVehicleId')
      @selectedVehicle = Vehicles.findOne _id: Session.get('selectedVehicleId')
      if @selectedVehicle?.lat
        @map.map.setCenter
          lat: @selectedVehicle.lat
          lng: @selectedVehicle.lon
      else
        Alerts.set 'This vehicle has no known position.'

  @autorun =>
    if @showGeofences.get()
      @geofences = {}
      map = @map.map
      Geofences.find().observe
        added: (gf) =>
          @geofences[gf._id] = new Geofence gf, map
        removed: (gf) =>
          @geofences[gf._id].destroy()
          delete @geofences[gf._id]
        changed: (gf) =>
          @geofences[gf._id].destroy()
          delete @geofences[gf._id]
          @geofences[gf._id] = new Geofence gf, map
    else
      gf.destroy() for id, gf of @geofences
      @geofences = []

Template.fleetrMap.helpers
  selectedVehiclePath: ->
    selectedVehicle = Vehicles.findOne {_id: Session.get('selectedVehicleId')},
      fields: trip: 1
    map = Template.instance().map
    map?.removeCurrentPath()
    path = selectedVehicle?.trip?.path or []
    path = _.sortBy path, (p) -> p.time
    map?.renderPath path
    ''

Template.fleetrMap.events
  'click #pac-input-clear': -> $('#pac-input').val('')

  'click #show-geofences-check': (e, t) ->
    t.showGeofences.set e.target.checked
