Meteor.startup ->
  @Map =
    options:
      zoom: 12
      mapTypeId: google.maps.MapTypeId.ROADMAP
      disableDefaultUI: true
      streetViewControl: true
      streetViewControlOptions:
        position: google.maps.ControlPosition.LEFT_BOTTOM
      zoomControl: true
      zoomControlOptions:
          style: google.maps.ZoomControlStyle.SMALL
          position: google.maps.ControlPosition.LEFT_BOTTOM

    init: (cb) ->
      navigator.geolocation.getCurrentPosition Map.setup(cb), Map.setup(cb)

    # Location defaults to Sofia
    setup: (cb) -> (position = {coords: {latitude: 42.6959214, longitude: 23.3198662}}) ->
      Map.options.center = lat: position.coords.latitude, lng: position.coords.longitude
      Map.map = new google.maps.Map document.getElementById("map-canvas"), Map.options
      Map.vehicleClusterer = new FleetrClusterer Map.map

      google.maps.event.addListenerOnce Map.map, 'idle', Map.renderMarkers

      Map.addListener 'zoom_changed', -> Session.set('zoomLevel', Map.map.getZoom())

      Autocomplete.init Map.map
      cb && cb()

    renderMarkers: ->
      markers = Vehicles.find().map (vehicle) ->
        new VehicleMarker(vehicle).withInfo(vehicle, Map.map)
      Map.deleteVehicleMarkers()
      Map.showVehicleMarkers markers

    addListener: (event, listener) ->
      google.maps.event.addListener Map.map, event, listener

    showVehicleMarkers: (markers) ->
      Map.vehicleClusterer?.addMarkers(markers?.filter (m) -> m if m)

    setCenter: (location) ->
      Map.map?.setCenter(new FleetrLatLng(location)) if location

    deleteVehicleMarkers: -> Map.vehicleClusterer?.clearMarkers()

    getSearchArea: ->
      try
        bounds = Map.map.getBounds()
        if bounds
          ne = bounds.getNorthEast()
          sw = bounds.getSouthWest()
          center = bounds.getCenter()
          center: center, box: [[sw.lng(), sw.lat()], [ne.lng(), ne.lat()]]
