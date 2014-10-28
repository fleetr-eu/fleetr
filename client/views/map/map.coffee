Meteor.startup ->
  @Map =
    clusterer: null
    options:
      zoom: 12
      mapTypeId: google.maps.MapTypeId.ROADMAP
      disableDefaultUI: true
      zoomControl: true
      zoomControlOptions:
          style: google.maps.ZoomControlStyle.SMALL

    init: (cb) -> navigator.geolocation.getCurrentPosition Map.setup(cb), Map.setup(cb)

    setup: (cb) -> (position) ->
      position ?= {coords: {latitude: 42.6959214, longitude: 23.3198662}}
      Map.options.center = lat: position.coords.latitude, lng: position.coords.longitude
      Map.map = new google.maps.Map document.getElementById("map-canvas"), Map.options
      Map.clusterer = Map.createClusterer Map.map
      Map.addListener 'idle', -> Session.set 'mapArea', Map.getSearchArea()
      Map.addListener 'click', (e) ->
        Meteor.call 'addLocation', {loc: [e.latLng.lng(), e.latLng.lat()]}
      cb && cb()

    addListener: (event, listener) ->
      google.maps.event.addListener Map.map, event, listener

    addMarkers: (markers) -> Map.clusterer?.addMarkers markers

    deleteMarkers: -> Map.clusterer?.clearMarkers()

    getSearchArea: ->
      try
        bounds = Map.map.getBounds()
        if bounds
          ne = bounds.getNorthEast()
          sw = bounds.getSouthWest()
          center = bounds.getCenter()
          center: center, box: [[sw.lng(), sw.lat()], [ne.lng(), ne.lat()]]

    createClusterer: (map)->
      clustererOptions =
          zoomOnClick:false
          averageCenter:true
          gridSize:40
      new MarkerClusterer(map, [], clustererOptions)

Template.map.rendered = ->
  Map.init ->
    Deps.autorun ->
      Meteor.subscribe 'locations', Session.get('mapArea')?.box, Template.map.helpers.renderMarkers

Template.map.helpers
  renderMarkers: ->
      Map.deleteMarkers()
      markers = Locations.find().map (location) ->
        [lng, lat] = location.loc
        new google.maps.Marker(position: new google.maps.LatLng(lat, lng))
      Map.addMarkers markers
