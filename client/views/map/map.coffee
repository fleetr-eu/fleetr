Meteor.startup ->
  @Map =
    markers: []
    options:
      zoom: 12
      mapTypeId: google.maps.MapTypeId.ROADMAP
      disableDefaultUI: true
      zoomControl: true
      zoomControlOptions:
          style: google.maps.ZoomControlStyle.SMALL

    init: -> navigator.geolocation.getCurrentPosition Map.setup, Map.setup

    setup: (position) ->
      position ?= {coords: {latitude: 42.6959214, longitude: 23.3198662}}
      Map.options.center = lat: position.coords.latitude, lng: position.coords.longitude
      Map.map = new google.maps.Map document.getElementById("map-canvas"), Map.options
      Map.addListener 'idle', -> Session.set 'mapArea', Map.getSearchArea()
      Map.addListener 'click', (e) ->
        Meteor.call 'addLocation', {loc: [e.latLng.lng(), e.latLng.lat()]}

    addListener: (event, listener) ->
      google.maps.event.addListener Map.map, event, listener

    addMarker: (location) ->
      Map.markers.push(new google.maps.Marker(position: location, map: Map.map))

    setMarkersMap: (map) -> m.setMap(map) for m in Map.markers
    deleteMarkers: ->
      Map.setMarkersMap null
      Map.markers = []

    getSearchArea: ->
      try
        bounds = Map.map.getBounds()
        if bounds
          ne = bounds.getNorthEast()
          sw = bounds.getSouthWest()
          center = bounds.getCenter()
          center: center, box: [[sw.lng(), sw.lat()], [ne.lng(), ne.lat()]]

Template.map.rendered = ->
  Map.init()
  Deps.autorun ->
    Meteor.subscribe 'locations', Session.get('mapArea'), ->
      Map.deleteMarkers()
      Locations.find().forEach (location) ->
        [lng, lat] = location.loc
        Map.addMarker new google.maps.LatLng(lat, lng)
