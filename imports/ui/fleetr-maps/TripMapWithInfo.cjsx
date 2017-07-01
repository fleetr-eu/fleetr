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

speeding = <span className="glyphicon glyphicon-exclamation-sign" style={color: 'red'}></span>

TripMapWithInfo = React.createClass
  displayName: 'TripMapWithInfo'

  componentDidUpdate: ->
    if @props.scrollIntoView and selectedRow = @refs.selectedRow
      selectedRow.scrollIntoView()

  render: ->
    tripUi = []
    @props.trips.forEach (trip, i) =>
      style = if trip._id is @props.tripId then selectedStyle else {padding: 10, cursor: 'pointer'}
      ref = if trip._id is @props.tripId then 'selectedRow' else null
      tripUi.push <tr ref={ref} key={i} style={style} onClick={=> @props.onTripSelected trip, false}>
        <td style=tdStyle>{format trip.startTime}</td>
        <td style=tdStyle>&#8249; {Number((Number(trip.distance)).toFixed(0))} км {if trip.speeding then speeding} &#8250;</td>
        <td style=tdStyle>{format trip.stopTime}</td>
      </tr>
      if trip._id is @props.tripId
        [a, ..., z] = trip.logbook
        tripUi.push <tr style={selectedStyle} key='info'>
          <td colSpan={3} style={paddingLeft: 5, paddingRight: 5}>
            <div style={float:'left'}>{a.address}</div>
            <div style={float:'right'}>{z.address}</div><br/>
            <div style={float:'left'}>Средна: {Number((Number(trip.avgSpeed)).toFixed(0))} км/ч</div>
            <div style={float:'right'}>&nbsp;Максимална: {Number((Number(trip.maxSpeed)).toFixed(0))} км/ч</div>
          </td>
        </tr>
    unless @props.trips.length
      tripUi.push <tr key='loading'><td colSpan={3} style={textAlign: 'center'}>
        <div className="spinner"></div>
      </td></tr>
    <div>
      <MultiTripMap trips={@props.trips} selectedTripId={@props.tripId} onTripSelected={@props.onTripSelected} />
      <div style={width: 400, height: 'calc(100vh - 61px)', float:'right', backgroundColor: 'white', padding: 10, paddingTop: 0, overflowY: 'scroll'}>
        <h2 style={textAlign:'center', marginTop: 15, marginBottom: 0}><small>{@props.date}</small></h2>
        <h3 style={textAlign:'center', marginTop: 0, fontSize: 20}><small>{@props.vehicle?.name} &mdash; {@props.vehicle?.licensePlate}</small></h3>
        <table style={color: '#222', width: '100%', fontSize: 13}>
          <thead>
            <tr>
              <th style=centered50W>Start</th>
              <th style=centeredStyle></th>
              <th style=centered50W>Stop</th>
            </tr>
          </thead>
          <tbody>
            <tr>
              <td colSpan=3 style=beginFinishStyle>&mdash; Start &mdash;</td>
            </tr>
            {tripUi}
            <tr>
              <td colSpan=3 style=beginFinishStyle>&mdash; Finish &mdash;</td>
            </tr>
          </tbody>
        </table>
      </div>
    </div>

trips = new ReactiveVar null
selectedTripId = new ReactiveVar null
scrollIntoView = new ReactiveVar true
mapIdentity = null
module.exports = createContainer (props) ->
  unless trips.get() and mapIdentity is "#{props.date}#{props.deviceId}"
    mapIdentity = "#{props.date}#{props.deviceId}"
    trips.set []
    scrollIntoView.set true
    Meteor.call 'trips/single/day', props.deviceId, props.date, (err,data) ->
      trips.set data

  trips: trips.get() or []
  scrollIntoView: scrollIntoView.get()
  tripId: selectedTripId.get() or props.tripId
  onTripSelected: (trip, scroll = true) ->
    selectedTripId.set trip._id
    scrollIntoView.set scroll
, TripMapWithInfo
