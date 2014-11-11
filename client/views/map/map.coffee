Meteor.startup ->
  @Map =
    clusterer: null
    path: null
    options:
      zoom: 12
      mapTypeId: google.maps.MapTypeId.ROADMAP
      disableDefaultUI: true
      zoomControl: true
      zoomControlOptions:
          style: google.maps.ZoomControlStyle.SMALL

    init: (cb) ->
      navigator.geolocation.getCurrentPosition Map.setup(cb), Map.setup(cb)

    addLocation: (lat, lng, speed, stay) ->
        Meteor.call 'addLocation',
          loc: [lng, lat]
          speed: speed
          stay: stay
          vehicleId: Session.get('selectedVehicleId') || Random.choice _.pluck(Vehicles.find().fetch(), '_id')

    setup: (cb) -> (position) ->
      position ?= {coords: {latitude: 42.6959214, longitude: 23.3198662}}
      Map.options.center = lat: position.coords.latitude, lng: position.coords.longitude
      Map.map = new google.maps.Map document.getElementById("map-canvas"), Map.options
      Map.clusterer = Map.createClusterer Map.map
      Map.addListener 'idle', -> rerenderMarkers()

      Map.addListener 'click', (e) ->
        pos = {coords: {longitude: e.latLng.lng(), latitude: e.latLng.lat()}}
        Session.set("loggedVehicle", Session.get('selectedVehicleId'))
        Locations.save(pos)
        Session.set("loggedVehicle", "")
        
      input = document.getElementById("pac-input")
      pacSearch = document.getElementById("pac-search")
      Map.map.controls[google.maps.ControlPosition.TOP_LEFT].push pacSearch

      autocomplete = new google.maps.places.Autocomplete(input)
      autocomplete.bindTo "bounds", Map.map
      infowindow = new google.maps.InfoWindow()
      searchMarker = new google.maps.Marker
        map: Map.map
        anchorPoint: new google.maps.Point(0, -29)

      Map.clusterer?.setZoomOnClick true

      google.maps.event.addListener autocomplete, "place_changed", ->
        infowindow.close()
        searchMarker.setVisible false
        place = autocomplete.getPlace()
        return  unless place.geometry

        # If the place has a geometry, then present it on a map.
        if place.geometry.viewport
          Map.map.fitBounds place.geometry.viewport
        else
          Map.map.setCenter place.geometry.location
          Map.map.setZoom 17 # Why 17? Because it looks good.

        searchMarker.setIcon (
          url: place.icon
          size: new google.maps.Size(71, 71)
          origin: new google.maps.Point(0, 0)
          anchor: new google.maps.Point(17, 34)
          scaledSize: new google.maps.Size(35, 35)
        )
        searchMarker.setPosition place.geometry.location
        searchMarker.setVisible true
        address = ""
        if place.address_components
          address = [
            place.address_components[0] and place.address_components[0].short_name or ""
            place.address_components[1] and place.address_components[1].short_name or ""
            place.address_components[2] and place.address_components[2].short_name or ""
          ].join(" ")
        infowindow.setContent "<div><strong>" + place.name + "</strong><br>" + address
        infowindow.open Map.map, searchMarker
      cb && cb()

    addListener: (event, listener) ->
      google.maps.event.addListener Map.map, event, listener

    addMarkers: (markers) -> Map.clusterer?.addMarkers markers

    addPath: (locations) ->
      Map.deletePath()
      if locations
        path = locations.map (location) ->
          [lng, lat] = location.loc
          new google.maps.LatLng(lat, lng)
        optimzedPath = GDouglasPeucker(path, 5)

        Map.path = new google.maps.Polyline
          map: Map.map,
          path: optimzedPath,
          strokeColor: 'blue',
          strokeOpacity: 0.6,
          strokeWeight: 7

    deletePath: -> Map.path?.setMap null

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
  Map.init =>
    @autorun ->
      Meteor.subscribe 'locations', Session.get('selectedVehicleId')
    @autorun ->
      selectedVehicle = Vehicles.findOne _id: Session.get('selectedVehicleId')
      location = selectedVehicle?.lastLocation
      if location
          [lng, lat] = location.loc
          Map.map?.setCenter {lat: lat, lng: lng}
      Map.addPath selectedVehicle?.lastLocations().fetch()

rerenderMarkers = ->
    Map.deleteMarkers()
    vehicles = Vehicles.findFiltered 'vehicleFilter', ['licensePlate', 'tags']
    markers = vehicles.map (vehicle) ->
      location = vehicle.lastLocation
      if location
        [lng, lat] = location.loc
        truckIcon = if location.speed then '/images/truck-green.png' else '/images/truck-red.png'
        marker = new google.maps.Marker
          position: new google.maps.LatLng(lat, lng)
          title: Vehicles.findOne(_id: location.vehicleId).identificationNumber
          icon: truckIcon
          data: location
        google.maps.event.addListener marker, 'click', ->
          vehicle = Vehicles.findOne(_id: marker.data.vehicleId)
          infowindow = new google.maps.InfoWindow
            content: """
              <div style='width:10em;'>
                <p>ВИН: #{vehicle.identificationNumber}</p>
                <p>Номер: #{vehicle.licensePlate}</p>
                <p>Скорост: #{parseFloat(Math.round(marker.data.speed * 100) / 100).toFixed(2)} км/ч</p>
                <p>Километраж: #{parseFloat(Math.round(marker.data.distance / 1000 * 100) / 100).toFixed(3)} км</p>
                <p>Престой: #{marker.data.stay}</p>
                <p><a href="/location/remove/#{marker.data._id}">Изтрий</a></p>
              </div>"""
          infowindow.open Map.map, marker
        marker
    Map.addMarkers markers.filter (m) -> m if m

Template.map.helpers
  renderMarkers: -> rerenderMarkers()

Template.map.created = -> Session.setDefault 'vehicleFilter', ''

Template.vehiclesMapTable.helpers
  vehicles: -> Vehicles.findFiltered 'vehicleFilter', ['licensePlate', 'tags']
  selectedVehicleId: -> Session.get('selectedVehicleId')

Template.vehicleMapTableRow.helpers
  fleetName: -> Fleets.findOne(_id : @allocatedToFleet).name
  active: -> if @_id == Session.get('selectedVehicleId') then 'active' else ''
  allocatedToFleetFromDate: -> @allocatedToFleetFromDate.toLocaleDateString()
  tagsArray: -> tagsAsArray.call @

Template.vehicleMapTableRow.events
  'click tr': -> Session.set 'selectedVehicleId', @_id
  'click .filter-tag': (e) ->
    tag = e.target.innerText
    $('#vehicles #filter').val(tag)
    Session.set 'vehicleFilter', tag

Template.map.events
  'click #pac-input-clear': ->
    $('#pac-input').val('')
