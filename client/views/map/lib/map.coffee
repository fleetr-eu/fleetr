Meteor.startup ->
  @Map =
    path: {infoMarkers: []}
    options:
      zoom: 12
      mapTypeId: google.maps.MapTypeId.ROADMAP
      disableDefaultUI: true
      streetViewControl: true
      zoomControl: true
      zoomControlOptions:
          style: google.maps.ZoomControlStyle.SMALL

    init: (cb) ->
      navigator.geolocation.getCurrentPosition Map.setup(cb), Map.setup(cb)

    setup: (cb) -> (position) ->
      position ?= {coords: {latitude: 42.6959214, longitude: 23.3198662}}
      Map.options.center = lat: position.coords.latitude, lng: position.coords.longitude
      Map.map = new google.maps.Map document.getElementById("map-canvas"), Map.options
      Map.speedClusterer = createSpeedClusterer Map.map
      Map.stayClusterer = createStayClusterer Map.map
      Map.vehicleClusterer = createVehicleClusterer Map.map

      google.maps.event.addListenerOnce Map.map, 'idle', Map.renderMarkers

      Map.addListener 'zoom_changed', -> Session.set('zoomLevel', Map.map.getZoom())

      Autocomplete.init Map.map
      cb && cb()

    renderMarkers: ->
      markers = Vehicles.findFiltered('vehicleFilter', ['licensePlate', 'tags']).map (vehicle) ->
        new VehicleMarker(vehicle).withInfo(vehicle, Map.map)
      Map.deleteVehicleMarkers()
      Map.showVehicleMarkers markers

      if Session.get('selectedVehicleId')
        selectedVehicle = Vehicles.findOne _id: Session.get('selectedVehicleId')
        if selectedVehicle
          Map.setCenter [selectedVehicle.lat, selectedVehicle.lon]
          locations = selectedVehicle.lastLocations(100)
          Map.showPath locations
          Map.showPathMarkers selectedVehicle, locations

    addListener: (event, listener) ->
      google.maps.event.addListener Map.map, event, listener

    showVehicleMarkers: (markers) ->
      Map.vehicleClusterer?.addMarkers(markers?.filter (m) -> m if m)

    showPathMarkers: (vehicle) ->
      if vehicle
        locations = Logbook.find deviceId: vehicle.unitId
        locations?.forEach (location) ->
          if location?.speed >= Settings.maxSpeed
            m = new SpeedMarker(location).withInfo(vehicle, location, Map.map)
            Map.speedClusterer?.addMarker m
          if location?.stay >= Settings.maxStay
            m = new LongStayMarker(location).withInfo(vehicle, location, Map.map)
            Map.stayClusterer?.addMarker m

    setCenter: (location) ->
      Map.map?.setCenter(new FleetrLatLng(location)) if location

    showPath: (locations) ->
      console.log locations.fetch()
      Map.deletePath()
      if locations?.count() > 0
        path = locations.map (location) -> new FleetrLatLng location
        optimizedPath = GDouglasPeucker(path, (22 - Session.get('zoomLevel')) * 10)
        Map.path.polyline = new FleetrPolyline Map.map, optimizedPath

        Map.path.polyline.addListener 'click', (e) ->
          loc = Map.path.polyline.findNearestPoint(e.latLng).latLng.location
          infowindow = new FleetrInfoWindow loc.vehicle(), loc
          m = new EmptyMarker(loc, Map.map)
          Map.path.infoMarkers.push m
          infowindow.open Map.map, m

    deletePath: ->
      Map.path?.polyline?.setMap null
      Map.path?.infoMarkers?.forEach (m) -> m.setMap null
      Map.path = {infoMarkers: []}
      Map.speedClusterer?.clearMarkers()
      Map.stayClusterer?.clearMarkers()

    deleteVehicleMarkers: -> Map.vehicleClusterer?.clearMarkers()

    getSearchArea: ->
      try
        bounds = Map.map.getBounds()
        if bounds
          ne = bounds.getNorthEast()
          sw = bounds.getSouthWest()
          center = bounds.getCenter()
          center: center, box: [[sw.lng(), sw.lat()], [ne.lng(), ne.lat()]]
