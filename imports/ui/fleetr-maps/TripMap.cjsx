React               = require 'react'
{createContainer}   = require 'meteor/react-meteor-data'
Map                 = require '../maps/Map.cjsx'
Marker              = require '../maps/Marker.cjsx'
StartMarker         = require '../fleetr-maps/markers/StartMarker.cjsx'
StopMarker         = require '../fleetr-maps/markers/StopMarker.cjsx'
RoutePolyline       = require '../fleetr-maps/RoutePolyline.cjsx'
InfoWindow          = require '../maps/InfoWindow.cjsx'

VehicleLayer        = require '../fleetr-maps/VehicleLayer.cjsx'

TripMap = React.createClass
  displayName: 'TripMap'

  render: ->
    console.log 'TripMap', @props
    [start, ..., stop] = @props.points
    <Map centerAroundCurrentLocation=true style={height:'calc(100vh - 60px)'} onMove={-> console.log 'map moved'} onClick={(a,b,c)-> console.log 'clicked on map',a} >
      <RoutePolyline points={@props.points} />
      <StartMarker position={start}/>
      <StopMarker position={stop}/>
    </Map>

module.exports = createContainer (props) ->
  console.log 'props', props
  { tripId } = props.data
  searchArgs = if tripId
    'attributes.trip': tripId
  points = []
  console.log 'searchArgs',searchArgs
  if searchArgs
    Meteor.subscribe 'logbook', searchArgs
    points = Logbook.find(searchArgs, {sort: recordTime: 1}).fetch()
    console.log 'points', points

  points: points
, TripMap
