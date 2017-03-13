React       = require 'react'
Map         = require './maps/Map.cjsx'
Marker      = require './maps/Marker.cjsx'
InfoWindow  = require './maps/InfoWindow.cjsx'

module.exports  = React.createClass
  displayName: 'MapContainer'

  render: ->
    <Map centerAroundCurrentLocation=true style={height:'calc(100vh - 60px)'} onMove={-> console.log 'map moved'} onClick={-> console.log 'clicked on map'} >
      <Marker onClick={-> console.log 'you clicked me!'}>
        <InfoWindow><h3>Dit is een test!</h3></InfoWindow>
      </Marker>
      <Marker position={lat:46.8029057, lng:11.7545206} onDblClick={-> console.log 'dblclick'}>
        <InfoWindow oncloseclick={-> console.log 'info window closed'}>Andere content</InfoWindow>
      </Marker>
    </Map>
