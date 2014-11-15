Meteor.startup ->
  @Map =
    path: {infoMarkers: []}
    options:
      zoom: 12
      mapTypeId: google.maps.MapTypeId.ROADMAP
      disableDefaultUI: true
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
      Map.vehicleClusterer = createVehicleClusterer Map.map

      google.maps.event.addListenerOnce Map.map, 'idle', Map.renderMarkers
      Map.addListener 'click', (e) ->
        pos = {coords: {longitude: e.latLng.lng(), latitude: e.latLng.lat()}}
        Locations.save(Session.get('selectedVehicleId'), pos)

      Autocomplete.init Map.map
      cb && cb()

    renderMarkers: ->
      markers = Vehicles.findFiltered('vehicleFilter', ['licensePlate', 'tags']).map (vehicle) ->
        location = vehicle.lastLocation
        if location
          new VehicleMarker(vehicle, location).withInfo(vehicle, @location, Map.map)
      Map.deleteVehicleMarkers()
      Map.showVehicleMarkers markers

      selectedVehicle = Vehicles.findOne _id: Session.get('selectedVehicleId')
      Map.setCenter selectedVehicle?.lastLocation
      locations = selectedVehicle?.lastLocations()
      Map.showPath locations
      Map.showSpeedMarkers selectedVehicle, locations

    addLocation: (lat, lng, speed, stay) ->
      Meteor.call 'addLocation',
        loc: [lng, lat]
        speed: speed
        stay: stay
        vehicleId: Session.get('selectedVehicleId') || Random.choice _.pluck(Vehicles.find().fetch(), '_id')

    addListener: (event, listener) ->
      google.maps.event.addListener Map.map, event, listener

    showVehicleMarkers: (markers) ->
      Map.vehicleClusterer?.addMarkers(markers?.filter (m) -> m if m)

    showSpeedMarkers: (vehicle, speedLocations) ->
      speedMarkers = speedLocations?.map (location) ->
        new SpeedMarker(location).withInfo(vehicle, location, Map.map)
      Map.speedClusterer?.addMarkers(speedMarkers?.filter (m) -> m if m)

    setCenter: (location) ->
      if location
        [lng, lat] = location.loc
        Map.map?.setCenter {lat: lat, lng: lng}

    showPath: (locations) ->
      Map.deletePath()
      if locations?.count() > 0
        path = locations.map (location) -> new FleetrLatLng location
        optimizedPath = GDouglasPeucker(path, 5)
        Map.path.polyline = new FleetrPolyline Map.map, path

        Map.path.polyline.addListener 'click', (e) ->
          loc = Map.path.polyline.findNearestPoint(e.latLng).location
          infowindow = new FleetrInfoWindow loc.vehicle(), loc
          m = new EmptyMarker(loc, Map.map)
          Map.path.infoMarkers.push m
          infowindow.open Map.map, m

    deletePath: ->
      Map.path?.polyline?.setMap null
      Map.path?.infoMarkers?.forEach (m) -> m.setMap null
      Map.path = {infoMarkers: []}
      Map.speedClusterer?.clearMarkers()

    deleteVehicleMarkers: -> Map.vehicleClusterer?.clearMarkers()

    getSearchArea: ->
      try
        bounds = Map.map.getBounds()
        if bounds
          ne = bounds.getNorthEast()
          sw = bounds.getSouthWest()
          center = bounds.getCenter()
          center: center, box: [[sw.lng(), sw.lat()], [ne.lng(), ne.lat()]]
