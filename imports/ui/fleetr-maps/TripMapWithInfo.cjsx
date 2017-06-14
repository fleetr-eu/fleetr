React               = require 'react'
{createContainer}   = require 'meteor/react-meteor-data'
moment              = require 'moment'
MultiTripMap        = require './MultiTripMap.cjsx'

format = (value) -> moment(value).format('HH:mm:ss')

TripMapWithInfo = React.createClass
  displayName: 'TripMapWithInfo'

  render: ->
    tripsPoints = @props.trips.map (t) -> t.logbook
    console.log 'tripsPoints!', tripsPoints
    <div>
      <MultiTripMap tripsPoints={tripsPoints} selectedTripId={@props.tripId} />
      <div style={width: 400, height: 'calc(100vh - 60px)', float:'right', backgroundColor: 'white', padding: 10, paddingTop: 0}>
        <h2 style={margin:0}><small>Trips for {@props.trips?[0]?.date}</small></h2>
        <table style={color: '#222', width: '100%'}>
          <tr>
            <th>&#35;</th>
            <th>Start</th>
            <th>End</th>
            <th>Distance</th>
          </tr>
          {@props.trips.map (trip, i) =>
            style = if trip._id is @props.tripId then fontWeight: 'bold' else {}
            <tr style={style} onClick={=> @props.onTripSelected trip}>
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
      Meteor.call 'trips/single/day', props.data.deviceId, moment(points[0]?.recordTime).toDate(), (err,data) ->
        console.log 'trips/single/day', err, data
        trips.set data
      # Meteor.call 'vehicle/trips', {}, {deviceId:props.data.deviceId, date: moment(points[0]?.recordTime).toDate()}, (err, data) ->
      #   console.log 'vehicle/trips', err, data
      #   trips.set data
      #   collector = []
      #   data.forEach (d, i) ->
      #     searchArgs = 'attributes.trip': d._id
      #     console.log 'more searching', searchArgs
      #     collector.push Logbook.find(searchArgs, {sort: recordTime: 1}).fetch()
      #     if i is data.length -1
      #       tripsPoints.push collector


  points: points
  trips: trips.get()
  tripId: tripId
  onTripSelected: (trip) -> _tripId.set trip._id
, TripMapWithInfo
