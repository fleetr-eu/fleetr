Meteor.startup ->
  class @FleetrLatLng extends google.maps.LatLng
    constructor: (@location) ->
      [lat, lng] = @location
      super lat, lng

  class FleetrMarker extends MarkerWithLabel
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
        else
          if vehicle.speed < Settings.minSpeed
            color = 'cyan'
      truckIcon = "/images/truck-#{color}.png"

      super
        position: new FleetrLatLng [vehicle.lat, vehicle.lon]
        title: "#{vehicle?.name} (#{vehicle?.licensePlate})"
        icon: #truckIcon
          path: google.maps.SymbolPath.FORWARD_CLOSED_ARROW 
          scale: 4
          strokeWeight: 2
          fillOpacity: 0.8
          fillColor: color
          rotation: (vehicle?.course or 0) + (vehicle?.courseCorrection or 0)
        labelContent: vehicle?.name + ' ('+vehicle?.licensePlate+')'
        labelAnchor: new google.maps.Point(-15, 20)
        labelClass: "navy-bold-semitransparent" # the CSS class for the label
        zIndex: 100
        id: vehicle?._id

  class @FleetrInfoWindow extends google.maps.InfoWindow
    constructor: (vehicle) ->
      vehicle = vehicle || Vehicles.findOne(_id: Session.get('selectedVehicleId'))
      driver = Drivers.findOne(_id: vehicle?.driver_id)
      driverName = if driver then "#{driver.firstName} #{driver.name}" else ""
      speed = vehicle.speed?.toFixed(2) || 'Unknown'
      km = (vehicle.odometer / 1000)?.toFixed(0) || 'Unknown'
      stayText = if (vehicle.state is "stop") then "Престой: #{moment.duration(location.stay,'seconds').humanize()}" else ""
      super
        content: """
                <div style='width:11em;'>
                  <p>
                  <b>#{vehicle.name} (#{vehicle.licensePlate})</b><br/>
                  Шофьор: #{driverName}<br/>
                  Скорост: #{speed} км/ч<br/>
                  Километраж: #{km} км<br/>
                  #{stayText}
                  </p>
                </div>"""


  class @SimpleInfoWindow extends google.maps.InfoWindow
    constructor: (data) ->
      super
        content: """
                  <p>Дата, час: #{moment(data.time).format('DD-MM-YYYY, HH:mm:ss')}<br/>
                  Скорост: #{data.speed} км/ч<br/>
                  Километраж: #{data.distance} км</p>
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