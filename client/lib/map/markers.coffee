Meteor.startup ->
  class @FleetrLatLng extends google.maps.LatLng
    constructor: (@location) ->
      [lng, lat] = @location?.loc
      super lat, lng

  class @EmptyMarker extends google.maps.Marker
    constructor: (location, map) ->
      super
        position: new FleetrLatLng location
        icon: 'none'
        map: map

  class @SpeedMarker extends google.maps.Marker
    constructor: (location) ->
      super
        position: new FleetrLatLng location
        icon: '/images/speed_100.png'
        zIndex: 10

  class @VehicleMarker extends google.maps.Marker
    constructor: (vehicle, @location) ->
      truckIcon =
        if @location.speed == 0
          if @location.stay < Settings.maxStay
            '/images/truck-blue.png'
          else
            '/images/truck-gray.png'
        else
          if @location.speed > Settings.maxSpeed
            '/images/truck-red.png'
          else '/images/truck-green.png'
      super
        position: new FleetrLatLng @location
        title: vehicle?.identificationNumber || @location.vehicle?.identificationNumber
        icon: truckIcon
        zIndex: 100

    addListener: (event, handler) -> google.maps.event.addListener @, event, handler

  class @FleetrInfoWindow extends google.maps.InfoWindow
    constructor: (vehicle, location) ->
      vehicle = vehicle || location.vehicle
      super
        content: """
                <div style='width:11em;'>
                  <p>ВИН: #{vehicle.identificationNumber}</p>
                  <p>Номер: #{vehicle.licensePlate}</p>
                  <p>Скорост: #{parseFloat(Math.round(location.speed * 100) / 100).toFixed(0)} км/ч</p>
                  <p>Километраж: #{parseFloat(Math.round(location.distance / 1000 * 100) / 100).toFixed(0)} км</p>
                  <p>Престой: #{location.stay}</p>
                  <p><a href="/location/remove/#{location._id}">Изтрий</a></p>
                </div>"""
