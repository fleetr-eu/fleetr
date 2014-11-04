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
        Meteor.call 'addLocation',
          loc: [e.latLng.lng(), e.latLng.lat()]
          speed: 50
          stay: 0
          vehicleId: Random.choice _.pluck(Vehicles.find().fetch(), '_id')
      Map.addListener 'rightclick', (e) ->
        Meteor.call 'addLocation',
          loc: [e.latLng.lng(), e.latLng.lat()]
          speed: 0
          stay: 30
          vehicleId: Random.choice _.pluck(Vehicles.find().fetch(), '_id')
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
      truckIcon = if location.speed then '/images/truck-green.png' else '/images/truck-red.png'
      marker = new google.maps.Marker
        position: new google.maps.LatLng(lat, lng)
        title: Vehicles.findOne(_id: location.vehicleId).identificationNumber
        icon: truckIcon
        data: location
      google.maps.event.addListener marker, 'click', ->
        infowindow = new google.maps.InfoWindow
          content: """
            <div style='width:10em;'>
              <p>ВИН: #{Vehicles.findOne(_id: marker.data.vehicleId).identificationNumber}</p>
              <p>Скорост: #{marker.data.speed}</p>
              <p>Престой: #{marker.data.stay}</p>
            </div>"""
        infowindow.open Map.map, marker
      marker
    Map.addMarkers markers
