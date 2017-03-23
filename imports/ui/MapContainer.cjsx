React               = require 'react'
Map                 = require './maps/Map.cjsx'
Marker              = require './maps/Marker.cjsx'
InfoWindow          = require './maps/InfoWindow.cjsx'

VehicleLayer        = require './fleetr-maps/VehicleLayer.cjsx'

module.exports = React.createClass
  displayName: 'MapContainer'

  render: ->
    <Map centerAroundCurrentLocation=true style={height:'calc(100vh - 60px)'} onMove={-> console.log 'map moved'} onClick={-> console.log 'clicked on map'} >
      <VehicleLayer />
    </Map>
