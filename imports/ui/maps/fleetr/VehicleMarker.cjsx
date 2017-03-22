React   = require 'react'
Marker  = require '../Marker.cjsx'

module.exports  = React.createClass
  displayName: 'VehicleMarker'

  render: ->
    v = @props.vehicle
    <Marker position={lat: v.lat, lng: v.lng} {...@props} />
