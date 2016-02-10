Meteor.startup ->
  @Map =
    geofences: []
    options:
      zoom: 12
      mapTypeId: google.maps.MapTypeId.ROADMAP
      disableDefaultUI: true
      streetViewControl: true
      mapTypeControl: true
      mapTypeControlOptions:
        position: google.maps.ControlPosition.LEFT_TOP
      streetViewControlOptions:
        position: google.maps.ControlPosition.LEFT_BOTTOM
      zoomControl: true
      zoomControlOptions:
          style: google.maps.ZoomControlStyle.SMALL
          position: google.maps.ControlPosition.LEFT_BOTTOM

    init: (pos, cb) ->
      if pos
        Map.setup(cb) {coords: {latitude: pos[1], longitude: pos[0]}}
      else
        navigator.geolocation.getCurrentPosition Map.setup(cb), Map.setup(cb)

    # Location defaults to Sofia
    setup: (cb) -> (position = {coords: {latitude: 42.6959214, longitude: 23.3198662}}) ->
      Map.options.center = lat: position.coords.latitude, lng: position.coords.longitude
      Map.map = new google.maps.Map document.getElementById("map-canvas"), Map.options

      if Map.vehicleClusterer
        Map.vehicleClusterer.setMap Map.map
      else
        Map.vehicleClusterer = new FleetrClusterer Map.map

      google.maps.event.addListenerOnce Map.map, 'idle', Map.renderMarkers

      Map.addListener 'zoom_changed', ->
        Session.set('zoomLevel', Map.map.getZoom())

      Autocomplete.init Map.map
      cb && cb()

    renderGeofences: ->
      Map.renderGeofence(gf) for gf in Geofences.find().fetch()

    removeGeofences: ->
      for gf in Map.geofences
        gf.circle.setMap null
        gf.label.close()
      Map.geofences = []

    renderGeofence: (gf) ->
      center = new google.maps.LatLng gf.center[1], gf.center[0]
      circle = @drawCircle center, gf.radius, Map.map
      label = @drawLabel center, gf.name, Map.map
      Map.geofences.push
        circle: circle
        label: label

    drawCircle: (center, radius, map) ->
      opts =
        map: map
        center: center
        radius: radius
        editable: false
        strokeColor: 'blue'
        strokeOpacity: 0.8
        strokeWeight: 2
        fillColor: 'blue'
        fillOpacity: 0.35
      new google.maps.Circle opts

    drawLabel: (center, text, map) ->
      opts =
        content: text
        boxStyle:
          textAlign: "center"
          fontSize: "8pt"
          width: "90px"
        disableAutoPan: true
        pixelOffset: new google.maps.Size(-45, 0)
        position: center
        closeBoxURL: ""
        isHidden: false
        enableEventPropagation: true
      label = new InfoBox opts
      label.open(map)
      label

    renderMarkers: ->
      markers = Vehicles.find().map (vehicle) ->
        new VehicleMarker(vehicle).withInfo(vehicle, Map.map)
      Map.deleteVehicleMarkers()
      Map.showVehicleMarkers markers

    renderPath: (path) ->
      Map.deleteCurrentPath()
      Map.showPath path

    showPath: (path) ->
      Map.currentPath = new FleetrPolyline Map.map, path

    deleteCurrentPath: ->
      Map.currentPath?.setMap null

    addListener: (event, listener) ->
      google.maps.event.addListener Map.map, event, listener

    showVehicleMarkers: (markers) ->
      Map.vehicleClusterer?.addMarkers(markers?.filter (m) -> m if m)

    setCenter: (location) ->
      Map.map?.setCenter(new FleetrLatLng(location)) if location

    deleteVehicleMarkers: -> Map.vehicleClusterer?.removeAllMarkers()

    getSearchArea: ->
      try
        bounds = Map.map.getBounds()
        if bounds
          ne = bounds.getNorthEast()
          sw = bounds.getSouthWest()
          center = bounds.getCenter()
          center: center, box: [[sw.lng(), sw.lat()], [ne.lng(), ne.lat()]]
