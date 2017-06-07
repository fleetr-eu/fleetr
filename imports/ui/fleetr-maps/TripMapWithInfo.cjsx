React               = require 'react'
{createContainer}   = require 'meteor/react-meteor-data'
moment              = require 'moment'
TripMap                 = require './TripMap.cjsx'

format = (value) -> moment(value).format('HH:mm:ss')

TripMapWithInfo = React.createClass
  displayName: 'TripMapWithInfo'

  render: ->
    <div>
      <TripMap points={@props.points} />
      <div style={width: 400, height: 'calc(100vh - 60px)', float:'right', backgroundColor: 'white', padding: 10}>
        <h2><small>Trips for {@props.trips?[0]?.date}</small></h2>
        <table style={color: '#222', width: '100%'}>
          <tr>
            <th>&#35;</th>
            <th>Start</th>
            <th>End</th>
            <th>Distance</th>
          </tr>
          {@props.trips.map (trip, i) =>
            <tr onClick={=> @props.onTripSelected trip}>
              <td>{i}</td>
              <td>{format trip.startTime}</td>
              <td>{format trip.stopTime}</td>
              <td>{trip.distance} km</td>
            </tr>
          }
        </table>
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
, TripMapWithInfo
