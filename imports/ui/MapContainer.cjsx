React       = require 'react'
Map         = require './maps/Map.cjsx'
Marker      = require './maps/Marker.cjsx'
InfoWindow  = require './maps/InfoWindow.cjsx'

module.exports  = React.createClass
  displayName: 'MapContainer'

  render: ->
    <Map centerAroundCurrentLocation=true style={height:'calc(100vh - 60px)'} onMove={-> console.log 'map moved'} >
      <Marker>
        <InfoWindow><h3>Dit is een test!</h3></InfoWindow>
      </Marker>
      <Marker position={lat:46.8029057, lng:11.7545206}>
        <InfoWindow>Andere content</InfoWindow>
      </Marker>
    </Map>
