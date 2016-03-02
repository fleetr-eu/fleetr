Template.fleetrMap.onCreated ->
  @showGeofences = new ReactiveVar false
  @showInfoMarkers = new ReactiveVar false

Template.fleetrMap.onRendered ->
  @map = new FleetrMap '#map-canvas',
    showVehicles: if @data.showVehicles is undefined then true else @data.showVehicles

  @autorun =>
    selectedVehicle = Vehicles.findOne _id: Session.get('selectedVehicleId')
    if selectedVehicle
      if selectedVehicle.lat
        @map.map.setCenter
          lat: selectedVehicle.lat
          lng: selectedVehicle.lon
      else
        sAlert.warning 'This vehicle has no known position.'

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
    t = Template.instance()
    map = t.map
    map?.removeCurrentPath()
    path = selectedVehicle?.trip?.path or []
    path = _.sortBy path, (p) -> p.time
    map?.renderPath path
    if t.showInfoMarkers.get()
      map?.showPathMarkers path
    else
      map?.hidePathMarkers()
    ''

Template.fleetrMap.events
  'click #pac-input-clear': -> $('#pac-input').val('')

  'click #show-geofences-check': (e, t) ->
    t.showGeofences.set e.target.checked

  'click #show-info-markers-check': (e, t) ->
    t.showInfoMarkers.set e.target.checked
