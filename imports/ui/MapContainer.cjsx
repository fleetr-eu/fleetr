React               = require 'react'
{ createContainer } = require 'meteor/react-meteor-data'
Map                 = require './maps/Map.cjsx'
Marker              = require './maps/Marker.cjsx'
InfoWindow          = require './maps/InfoWindow.cjsx'

VehicleMarker       = require './maps/fleetr/VehicleMarker.cjsx'

MapContainer = React.createClass
  displayName: 'MapContainer'

  render: ->
    <Map centerAroundCurrentLocation=true style={height:'calc(100vh - 60px)'} onMove={-> console.log 'map moved'} onClick={-> console.log 'clicked on map'} >
      <Marker onClick={-> console.log 'you clicked me!'}>
        <InfoWindow><h3>Dit is een test!</h3></InfoWindow>
      </Marker>
      <Marker position={lat:46.8029057, lng:11.7545206} onDblClick={-> console.log 'dblclick'}>
        <InfoWindow oncloseclick={-> console.log 'info window closed'}>Andere content</InfoWindow>
      </Marker>
      {@props.vehicles.map (v) -> <VehicleMarker vehicle={v} /> }
    </Map>

module.exports = createContainer (props) ->
  vehicles: Vehicles.find {},
    fields:
      state: 1
      name: 1
      lat: 1
      lng: 1
      speed: 1
      odometer: 1
      licensePlate: 1
      course: 1
      courseCorrection: 1
      driver_id: 1
      tripTime: 1
      idleTime: 1
      restTime: 1
, MapContainer
