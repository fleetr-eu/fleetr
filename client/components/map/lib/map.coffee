map = null
clusterer = null

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

    @currentMap: -> map

    constructor: (container, options) ->
      @vehicleMarkers = []
      @pathMarkers = []
      @geofences = {}
      @map = new google.maps.Map $(container)[0], _.extend @options, options

      showGeofences = document.getElementById("custom-map-controls")
      @map.controls[google.maps.ControlPosition.TOP_LEFT].push showGeofences

      Autocomplete.init @map, document.getElementById("pac-input")

      if clusterer
        @clusterer = clusterer
        @clusterer.setMap @map
        @clusterer.removeAllMarkers()
      else
        clusterer = @clusterer = new FleetrClusterer @map

      if options?.showVehicles
        @vehicleObserver = Vehicles.find {},
          fields:
            state: 1
            name: 1
            lat: 1
            lon: 1
            speed: 1
            odometer: 1
            licensePlate: 1
            course: 1
            courseCorrection: 1
            driver_id: 1
        .observe
          added: (v) => @addVehicleMarker v
          removed: (v) => @removeVehicleMarker v
          changed: (v) =>
            @removeVehicleMarker v
            @addVehicleMarker v

      map = @

    destroy: ->
      @removeAllMarkers()
      @vehicleObserver?.stop()

    addVehicleMarker: (vehicle) ->
      Tracker.autorun =>
        @removeVehicleMarker(vehicle) if @vehicleMarkers[vehicle._id]
        marker = new VehicleMarker(vehicle, Session.get('FleetrMap.showMarkerLabels')).withInfo(vehicle, @map)
        @vehicleMarkers[vehicle._id] = marker
        @clusterer.addMarker marker

    removeVehicleMarker: (vehicle) ->
      @clusterer.removeMarker vehicle._id
      delete @vehicleMarkers[vehicle._id]

    removeAllMarkers: ->
      @clusterer.removeAllMarkers()
      @removePathMarkers()

    moveVehicleMarker: (vehicle) ->
      @vehicleMarkers[vehicle._id].setPosition
        lat: vehicle.lat, lng: vehicle.lon

    renderPath: (@path) ->
      @currentPath = new FleetrPolyline @map, @path

    extendCurrentPath: (point) ->
      if @currentPath
        @currentPath.getPath().push point
      else
        @currentPath = new FleetrPolyline @map, [point]

    removeCurrentPath: ->
      @currentPath?.setMap null
      @currentPath = null
      @removePathMarkers()

    showPathMarkers: ->
      if @pathMarkers.length
        m.setMap @map for m in @pathMarkers
      else
        @path.map (point) =>
          color = if point.speed >= Settings.maxSpeed then 'red' else 'blue'
          opts =
            position: new google.maps.LatLng(point.lat, point.lng)
            icon: "/images/icons/#{color}-circle.png"
            map: @map
          info =
            speed: (point.speed or 0).toFixed(0)
            distance: (point.odometer/1000)?.toFixed(0)
            time: point.time
          @pathMarkers.push new InfoMarker opts, info

    hidePathMarkers: ->
      m.setMap(null) for m in @pathMarkers if @pathMarkers

    removePathMarkers: ->
      @hidePathMarkers()
      @pathMarkers = []
