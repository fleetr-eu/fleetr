React               = require 'react'
{createContainer}   = require 'meteor/react-meteor-data'
Map                 = require '../maps/Map.cjsx'
Marker              = require '../maps/Marker.cjsx'
Polyline            = require '../maps/Polyline.cjsx'
InfoWindow          = require '../maps/InfoWindow.cjsx'

VehicleLayer        = require '../fleetr-maps/VehicleLayer.cjsx'

TripMap = React.createClass
  displayName: 'TripMap'

  render: ->
    console.log 'TripMap', @props
    <Map centerAroundCurrentLocation=true style={height:'calc(100vh - 60px)'} onMove={-> console.log 'map moved'} onClick={(a,b,c)-> console.log 'clicked on map',a} >
      <Polyline path={@props.path} />
    </Map>

module.exports = createContainer (props) ->
  console.log 'props', props
  { tripId } = props.data
  searchArgs = if tripId
    'attributes.trip': tripId
  path = []
  console.log 'searchArgs',searchArgs
  if searchArgs
    Meteor.subscribe 'logbook', searchArgs, =>
      path = Logbook.find(searchArgs, {sort: recordTime: 1}).fetch()
      console.log 'path', path

  path: path
, TripMap
