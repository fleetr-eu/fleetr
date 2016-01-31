Meteor.startup ->
  @GeofenceMap =
    geofences: []
    options:
      zoom: 15
      mapTypeId: google.maps.MapTypeId.ROADMAP
      disableDefaultUI: true
      zoomControl: true
      zoomControlOptions:
          style: google.maps.ZoomControlStyle.SMALL

    init: (cb) ->
      navigator.geolocation.getCurrentPosition @setup(cb), @setup(cb)

    setup: (cb) -> (position) =>
      position ?= {coords: {latitude: 42.6959214, longitude: 23.3198662}}
      @options.center = lat: position.coords.latitude, lng: position.coords.longitude
      @map = new google.maps.Map document.getElementById("map-canvas"), @options

      @addListener 'click', (e) =>
        if Session.get('addGeofence')
          @circle?.setMap null
          @circle = @drawCircle(e.latLng, 100)

      cb && cb()

    addListener: (event, listener) ->
      google.maps.event.addListener @map, event, listener

    setCenter: (center) ->
      if center && @map
        [lng, lat] = center
        @map.setCenter(new google.maps.LatLng(lat, lng))

    clear: ->
      @geofences.map (gf) -> gf?.setMap(null)
      @geofences = []

    drawCircle: (center, radius, options) ->
      color = if options?.editable is false then 'blue' else 'red'
      opts =
        map: @map
        center: center
        radius: radius
        editable: true
        strokeColor: color
        strokeOpacity: 0.8
        strokeWeight: 2
        fillColor: color
        fillOpacity: 0.35
      opts = _.extend(opts, options)
      circle = new google.maps.Circle opts
      @geofences.push circle
      circle
