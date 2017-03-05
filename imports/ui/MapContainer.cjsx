React       = require 'react'
Map         = require './Map.cjsx'
Marker      = require './Marker.cjsx'
InfoWindow  = require './InfoWindow.cjsx'

module.exports  = React.createClass
  displayName: 'MapContainer'

  render: ->
    <Map centerAroundCurrentLocation=true style={height:'calc(100vh - 60px)'} >
      <Marker>
        <InfoWindow><h3>Dit is een test!</h3></InfoWindow>
      </Marker>
      <Marker position={lat:46.8029057, lng:11.7545206}>
        <InfoWindow>Andere content</InfoWindow>
      </Marker>
    </Map>
