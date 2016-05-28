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
    constructor: (vehicle, showLabel) ->
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

      opts =
        position: new FleetrLatLng [vehicle.lat, vehicle.lng]
        title: "#{vehicle?.name} (#{vehicle?.licensePlate})"
        icon:
          path: google.maps.SymbolPath.FORWARD_CLOSED_ARROW
          scale: 4
          strokeWeight: 2
          fillOpacity: 0.8
          fillColor: color
          rotation: (vehicle?.course or 0) + (vehicle?.courseCorrection or 0)
        zIndex: 100
        id: vehicle?._id

      if showLabel
        opts = _.extend opts,
          labelContent: vehicle?.name + ' ('+vehicle?.licensePlate+')'
          labelAnchor: new google.maps.Point(-15, 20)
          labelClass: "navy-bold-semitransparent" # the CSS class for the label

      super opts

  class @FleetrInfoWindow extends google.maps.InfoWindow
    constructor: (vehicle) ->
      vehicle = vehicle || Vehicles.findOne(_id: Session.get('selectedVehicleId'))
      tripTime = vehicle.tripTime
      idleTime = vehicle.idleTime
      restTime = vehicle.restTime
      console.log vehicle
      console.log "tripTime="+tripTime+", idleTime="+idleTime+", restTime="+restTime
      driver = Drivers.findOne(_id: vehicle?.driver_id)
      driverName = if driver then "#{driver.firstName} #{driver.name}" else ""
      speed = vehicle.speed?.toFixed(2) || 0
      km = (vehicle.odometer / 1000)?.toFixed(0) || 'Unknown'
      restText = if (vehicle.state is "stop") then "Престой: #{moment.duration(restTime,'milliseconds').humanize()}" else ""
      idleText = if (vehicle.state is "start") and (speed < Settings.minSpeed) then "На място: #{moment.duration(vehicle.idleime,'milliseconds').humanize()}" else ""
      tripText = if (vehicle.state is "start") and (speed >= Settings.minSpeed) then "В движение: #{moment.duration(vehicle.tripTime,'milliseconds').humanize()}" else ""
      super
        content: """
                <div style='width:11em;'>
                  <p>
                  <b>#{vehicle.name} (#{vehicle.licensePlate})</b><br/>
                  Шофьор: #{driverName}<br/>
                  Скорост: #{speed} км/ч<br/>
                  Километраж: #{km} км<br/>
                  #{tripText}
                  #{idleText}
                  #{restText}
                  </p>
                </div>"""


  class @SimpleInfoWindow extends google.maps.InfoWindow
    constructor: (data) ->
      super
        content: """
                  <p>Дата, час: #{moment(data.time).format('DD-MM-YYYY, HH:mm:ss')}<br/>
                  Скорост: #{data.speed} км/ч<br/>
                  Километраж: #{data.distance} км</p>
                  #{tripText}
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
