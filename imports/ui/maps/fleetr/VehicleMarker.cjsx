React   = require 'react'
Marker  = require '../Marker.cjsx'

module.exports  = React.createClass
  displayName: 'VehicleMarker'

  getIcon: (vehicle) ->
    getIconColor = ->
      color = 'grey'
      if vehicle.state is "stop"
        color = "blue"
      if vehicle.state is "start"
        color = 'green'
        if vehicle.speed > Settings.maxSpeed
          color = 'red'
        else if vehicle.speed < Settings.minSpeed then color = 'cyan'
      color

    path: google.maps.SymbolPath.FORWARD_CLOSED_ARROW
    scale: 4
    strokeWeight: 2
    fillOpacity: 0.8
    fillColor: getIconColor()
    rotation: (vehicle.course or 0) + (vehicle.courseCorrection or 0)

  render: ->
    v = @props.vehicle
    <Marker position={lat: v.lat, lng: v.lng} {...@props}
      title="#{v?.name} (#{v?.licensePlate})"
      icon={@getIcon v} />
