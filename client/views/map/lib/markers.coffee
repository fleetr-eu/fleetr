Meteor.startup ->
  class @FleetrLatLng extends google.maps.LatLng
    constructor: (@location) ->
      [lat, lng] = @location
      super lat, lng

  class FleetrMarker extends google.maps.Marker
    addListener: (event, handler) ->
      google.maps.event.addListener @, event, handler
      @

    withInfo: (vehicle, map) ->
      @addListener 'click', ->
        @infoWindow?.close()
        @infoWindow = new FleetrInfoWindow(vehicle)
        @infoWindow.open map, @

  class @EmptyMarker extends FleetrMarker
    constructor: (location, map) ->
      super
        position: new FleetrLatLng location
        icon: 'none'
        map: map

  class @SpeedMarker extends FleetrMarker
    constructor: (@location) ->
      super
        position: new FleetrLatLng location
        icon: '/images/speed/100.png'
        zIndex: 10

  class @LongStayMarker extends FleetrMarker
    constructor: (@location) ->
      super
        position: new FleetrLatLng location
        icon: '/images/stay/clock-red.png'
        zIndex: 15

  class @VehicleMarker extends FleetrMarker
    constructor: (vehicle) ->
      color = 'grey'
      if vehicle.state is "stop"
        color = "blue"
      if vehicle.state is "start"
        color = 'green'
        if vehicle.speed > Settings.maxSpeed
          color = 'red'
      truckIcon = "/images/truck-state-#{color}.png"

      super
        position: new FleetrLatLng [vehicle.lat, vehicle.lon]
        title: "#{vehicle?.name} (#{vehicle?.licensePlate})"
        icon: truckIcon
        zIndex: 100
        id: vehicle?._id

  class @FleetrInfoWindow extends google.maps.InfoWindow
    constructor: (vehicle) ->
      vehicle = vehicle || Vehicles.findOne(_id: Session.get('selectedVehicleId'))
      speed = vehicle.speed?.toFixed(2) || 'Unknown'
      km = (vehicle.odometer / 1000)?.toFixed(3) || 'Unknown'
      super
        content: """
                <div style='width:11em;'>
                  <p>Име: #{vehicle.name}</p>
                  <p>Номер: #{vehicle.licensePlate}</p>
                  <p>Скорост: #{speed} км/ч</p>
                  <p>Километраж: #{km} км</p>
                  <p>Престой: #{moment.duration(location.stay,'seconds').humanize()}</p>
                </div>"""


  class @SimpleInfoWindow extends google.maps.InfoWindow
    constructor: (data) ->
      super
        content: """
                  <p>Скорост: #{data.speed} км/ч</p>
                  <p>Километраж: #{data.distance} км</p>
                """

  class @InfoMarker extends google.maps.Marker
    constructor: (opts, info) ->
      super opts
      @addListener 'click', =>
        @infoWindow ?= new SimpleInfoWindow(info)
        @infoWindow.open opts.map, @

    addListener: (event, handler) ->
      google.maps.event.addListener @, event, handler
      @
