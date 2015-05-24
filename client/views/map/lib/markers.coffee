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
        new FleetrInfoWindow(vehicle).open map, @

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
      truckIcon =
        if vehicle.speed <= Settings.zeroSpeed
          if vehicle.stay < (vehicle.alarms?.idleAlarmTime || Settings.maxStay)
            '/images/truck-blue.png'
          else
            '/images/truck-gray.png'
        else
          if vehicle.speed > (vehicle.alarms?.speedingAlarmSpeed || Settings.maxSpeed)
            '/images/truck-red.png'
          else '/images/truck-green.png'
      super
        position: new FleetrLatLng [vehicle.lat, vehicle.lon]
        title: "#{vehicle?.name} (#{vehicle?.licensePlate})"
        icon: truckIcon
        zIndex: 100

  class @FleetrInfoWindow extends google.maps.InfoWindow
    constructor: (vehicle) ->
      vehicle = vehicle || Vehicles.findOne(_id: Session.get('selectedVehicleId'))
      super
        content: """
                <div style='width:11em;'>
                  <p>ВИН: #{vehicle.identificationNumber}</p>
                  <p>Номер: #{vehicle.licensePlate}</p>
                  <p>Скорост: #{vehicle.speed.toFixed(2)} км/ч</p>
                  <p>Километраж: #{(vehicle.odometer / 1000).toFixed(3)} км</p>
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
