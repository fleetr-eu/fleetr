Template.fleetrMap.onCreated ->
  @showGeofences = new ReactiveVar false
  @showInfoMarkers = new ReactiveVar false
  @showTraffic = ReactiveVar false 
  @trafficLayer = new google.maps.TrafficLayer();

  Session.set 'FleetrMap.showMarkerLabels', true

Template.fleetrMap.onDestroyed ->
  @map.destroy()

Template.fleetrMap.onRendered ->
  @map = new FleetrMap '#map-canvas',
    showVehicles: if @data.showVehicles is undefined then true else @data.showVehicles
  centerMapOnVehicleSelection()

  @autorun =>
    if @showTraffic.get()
      map = @map.map
      @trafficLayer.setMap(map)
    else 
      @trafficLayer.setMap(null)

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
  enableVehicleSelection: ->
    if Template.instance().data.enableVehicleSelection is undefined
      true
    else
      Template.instance().data.enableVehicleSelection

  selectedVehiclePath: ->
    t = Template.instance()
    selectedVehicle = Vehicles.findOne {_id: t.data.vehicleId},
      fields: trip: 1
    map = t.map
    if selectedVehicle?.trip?.id
      path = Logbook.find({'attributes.trip': selectedVehicle?.trip?.id}, {sort: recordTime: 1}).fetch()
      map?.removeCurrentPath()
      map?.renderPath path
    ''

  infoMarkers: ->
    t = Template.instance()
    selectedVehicle = Vehicles.findOne {_id: t.data.vehicleId},
      fields: trip: 1
    if t.showInfoMarkers.get()
      t.map?.showPathMarkers()
    else
      t.map?.hidePathMarkers()
    ''

  centerMapOnVehicleSelection: centerMapOnVehicleSelection = ->
    t = Template.instance()
    selectedVehicle = Vehicles.findOne {_id: t.data.vehicleId},
      fields:
        lat: 1
        lng: 1
      reactive: false
    if selectedVehicle
      if selectedVehicle.lat
        t.map?.map.setCenter
          lat: selectedVehicle.lat
          lng: selectedVehicle.lng
      else
        sAlert.warning 'This vehicle has no known position.'

Template.fleetrMap.events
  'click #pac-input-clear': -> $('#pac-input').val('')

  'click #show-geofences-check': (e, t) ->
    t.showGeofences.set e.target.checked

  'click #show-info-markers-check': (e, t) ->
    t.showInfoMarkers.set e.target.checked

  'click #show-marker-labels-check': (e, t) ->
    Session.set 'FleetrMap.showMarkerLabels', e.target.checked

  'click #show-traffic-check': (e, t) ->
     t.showTraffic.set e.target.checked
