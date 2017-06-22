React               = require 'react'
Map                 = require '../maps/Map.cjsx'
StartMarker         = require '../fleetr-maps/markers/StartMarker.cjsx'
StopMarker         = require '../fleetr-maps/markers/StopMarker.cjsx'
RoutePolyline       = require '../fleetr-maps/RoutePolyline.cjsx'

module.exports = TripMap = React.createClass
  displayName: 'TripMap'

  render: ->
    [start, ..., stop] = @props.points
    <Map style={height:'calc(100vh - 60px)', width:'calc(100% - 400px)', float: 'left'} onMove={-> console.log 'map moved'} onClick={(a,b,c)-> console.log 'clicked on map',a} >
      <RoutePolyline points={@props.points} />
      <StartMarker position={start}/>
      <StopMarker position={stop}/>
    </Map>
