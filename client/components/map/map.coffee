Meteor.startup ->
  class @Geofence
    constructor: (@gf, @map) ->
      @center = new google.maps.LatLng @gf.center[1], @gf.center[0]
      @circle = @_drawCircle()
      @label = @_drawLabel()

    destroy: ->
      @circle.setMap null
      @label.close()

    _drawCircle: ->
      opts =
        map: @map
        center: @center
        radius: @gf.radius
        editable: false
        strokeColor: 'blue'
        strokeOpacity: 0.8
        strokeWeight: 2
        fillColor: 'blue'
        fillOpacity: 0.35
      new google.maps.Circle opts

    _drawLabel: ->
      opts =
        content: @gf.name
        boxStyle:
          textAlign: "center"
          fontSize: "8pt"
          width: "90px"
        disableAutoPan: true
        pixelOffset: new google.maps.Size(-45, 0)
        position: @center
        closeBoxURL: ""
        isHidden: false
        enableEventPropagation: true
      label = new InfoBox opts
      label.open(@map)
      label

  class @FleetrMap
    options:
      center: # Sofia, Bulgaria
        lat: 42.6959214
        lng: 23.3198662
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

    constructor: (container, options) ->
      @vehicleMarkers = []
      @geofences = {}
      @map = new google.maps.Map $(container)[0], _.extend @options, options
      Autocomplete.init @map
      @clusterer = new FleetrClusterer @map

    addVehicleMarker: (vehicle) ->
      marker = new VehicleMarker(vehicle, @map).withInfo(vehicle, @map)
      @vehicleMarkers[vehicle._id] = marker
      @clusterer.addMarker marker

    removeVehicleMarker: (vehicle) ->
      @clusterer.removeMarker vehicle._id
      delete @vehicleMarkers[vehicle._id]

    moveVehicleMarker: (vehicle) ->
      @vehicleMarkers[vehicle._id].setPosition
        lat: vehicle.lat, lng: vehicle.lon

    renderPath: (path) ->
      @currentPath = new FleetrPolyline @map, path

    extendCurrentPath: (point) ->
      if @currentPath
        @currentPath.getPath().push point
      else
        @currentPath = new FleetrPolyline @map, [point]

    removeCurrentPath: ->
      @currentPath?.setMap null
      @currentPath = null
