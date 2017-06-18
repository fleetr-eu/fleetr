React               = require 'react'
{createContainer}   = require 'meteor/react-meteor-data'
moment              = require 'moment'
MultiTripMap        = require './MultiTripMap.cjsx'

format = (value) -> moment(value).format('HH:mm')
tdStyle = paddingBottom: 'inherit', paddingTop: 'inherit', textAlign: 'center'
centeredStyle = textAlign: 'center', paddingBottom: 10
centered50W = Object.assign {}, centeredStyle, {width: 50}
beginFinishStyle = Object.assign {}, centeredStyle, {paddingBottom: 15},  {color: 'grey'}, {fontSize: 18}
selectedStyle =
  color: 'white'
  fontWeight: 'bold'
  backgroundColor: '#5387c8'
  padding: 20

TripMapWithInfo = React.createClass
  displayName: 'TripMapWithInfo'

  componentDidUpdate: ->
    if selectedRow = @refs.selectedRow
      selectedRow.scrollIntoView()

  render: ->
    <div>
      <MultiTripMap trips={@props.trips} selectedTripId={@props.tripId} onTripSelected={@props.onTripSelected} />
      <div style={width: 400, height: 'calc(100vh - 61px)', float:'right', backgroundColor: 'white', padding: 10, paddingTop: 0, overflowY: 'scroll'}>
        <h2 style={textAlign:'center', marginTop: 15, marginBottom: 0}><small>{@props.trips?[0]?.date}</small></h2>
        <h3 style={textAlign:'center', marginTop: 0, fontSize: 20}><small>{@props.vehicle?.name} &mdash; {@props.vehicle?.licensePlate}</small></h3>
        <table style={color: '#222', width: '100%', fontSize: 16}>
          <tr>
            <th style=centered50W>Start</th>
            <th style=centeredStyle></th>
            <th style=centered50W>Stop</th>
          </tr>
          <tr>
            <td colSpan=3 style=beginFinishStyle>&mdash; Start &mdash;</td>
          </tr>
          {@props.trips.map (trip, i) =>
            style = if trip._id is @props.tripId then selectedStyle else {padding: 10, cursor: 'pointer'}
            ref = if trip._id is @props.tripId then 'selectedRow' else null
            <tr ref={ref} key={i} style={style} onClick={=> @props.onTripSelected trip}>
              <td style=tdStyle>{format trip.startTime}</td>
              <td style=tdStyle>&#8249; {trip.distance} km &#8250;</td>
              <td style=tdStyle>{format trip.stopTime}</td>
            </tr>
          }
          <tr>
            <td colSpan=3 style=beginFinishStyle>&mdash; Finish &mdash;</td>
          </tr>
        </table>
      </div>
    </div>

trips = new ReactiveVar null
selectedTripId = new ReactiveVar null
module.exports = createContainer (props) ->
  console.log 'props', props
  unless trips.get()
    Meteor.call 'trips/single/day', props.deviceId, props.date, (err,data) ->
      console.log 'trips/single/day', err, data
      trips.set data

  trips: trips.get() or []
  tripId: selectedTripId.get() or props.tripId
  onTripSelected: (trip) -> selectedTripId.set trip._id
, TripMapWithInfo
