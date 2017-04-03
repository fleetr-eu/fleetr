React               = require 'react'
Map                 = require './maps/Map.cjsx'
Marker              = require './maps/Marker.cjsx'
Polyline            = require './maps/Polyline.cjsx'
InfoWindow          = require './maps/InfoWindow.cjsx'

VehicleLayer        = require './fleetr-maps/VehicleLayer.cjsx'

path = [
          {lat: 37.772, lng: -122.214},
          {lat: 21.291, lng: -157.821},
          {lat: -18.142, lng: 178.431},
          {lat: -27.467, lng: 153.027}
        ]

module.exports = React.createClass
  displayName: 'MapContainer'

  render: ->
    <Map centerAroundCurrentLocation=true style={height:'calc(100vh - 60px)'} onMove={-> console.log 'map moved'} onClick={(a,b,c)-> console.log 'clicked on map',a} >
      <VehicleLayer />
      <Polyline path={path} />
    </Map>
