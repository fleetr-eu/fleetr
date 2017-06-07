React               = require 'react'
{createContainer}   = require 'meteor/react-meteor-data'
moment              = require 'moment'
Map                 = require '../maps/Map.cjsx'
Marker              = require '../maps/Marker.cjsx'
StartMarker         = require '../fleetr-maps/markers/StartMarker.cjsx'
StopMarker         = require '../fleetr-maps/markers/StopMarker.cjsx'
RoutePolyline       = require '../fleetr-maps/RoutePolyline.cjsx'
InfoWindow          = require '../maps/InfoWindow.cjsx'

VehicleLayer        = require '../fleetr-maps/VehicleLayer.cjsx'

format = (value) -> moment(value).format('HH:mm:ss')

TripMap = React.createClass
  displayName: 'TripMap'

  render: ->
    console.log 'TripMap', @props
    [start, ..., stop] = @props.points
    <div>
      <Map style={height:'calc(100vh - 60px)', width:'calc(100% - 400px)', float: 'left'} onMove={-> console.log 'map moved'} onClick={(a,b,c)-> console.log 'clicked on map',a} >
        <RoutePolyline points={@props.points} />
        <StartMarker position={start}/>
        <StopMarker position={stop}/>
      </Map>
      <div style={width: 400, height: 'calc(100vh - 60px)', float:'right', backgroundColor: 'white', padding: 10}>
        <h2><small>Trips for {@props.trips?[0]?.date}</small></h2>
        {@props.trips.map (trip, i) =>
          <div key={i} onClick={=> @props.onTripSelected trip}>
            {i}. {format trip.startTime} - {format trip.stopTime}
            {trip.distance}km
          </div>
        }
      </div>
    </div>

trips = new ReactiveVar []
_tripId = new ReactiveVar null
module.exports = createContainer (props) ->
  console.log 'props', props
  tripId = _tripId.get() or props.data.tripId
  searchArgs = if tripId
    'attributes.trip': tripId
  points = []
  console.log 'searchArgs',searchArgs
  if searchArgs
    Meteor.subscribe 'logbook', searchArgs
    points = Logbook.find(searchArgs, {sort: recordTime: 1}).fetch()
    console.log 'points', points

    unless trips.get().length
      Meteor.call 'vehicle/trips', {}, {deviceId:props.data.deviceId, timeRange: 'day'}, (err, data) ->
        console.log 'vehicle/trips', err, data
        trips.set data


  points: points
  trips: trips.get()
  onTripSelected: (trip) -> _tripId.set trip._id
, TripMap
