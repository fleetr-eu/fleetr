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
infoWindowStyle =
  width: '100%'
  height: 150
  padding: 10
  color: '#222222'
  boxShadow: '0 4px 8px 0 rgba(0,0,0,0.3)'
infoWindowPropTitle =
  width: 120
  fontWeight: 'bold'

speeding = <span className="glyphicon glyphicon-exclamation-sign" style={color: 'red'}></span>

TripMapWithInfo = React.createClass
  displayName: 'TripMapWithInfo'

  componentDidUpdate: ->
    if @props.scrollIntoView and selectedRow = @refs.selectedRow
      selectedRow.scrollIntoView()

  renderInfoWindow: (trip) ->
    [a, ..., z] = trip.logbook
    <div style={infoWindowStyle}>
      <table>
        <tr><td style={infoWindowPropTitle}>{TAPi18n.__('trip.details.startAddress')}</td><td>{a.address}</td></tr>
        <tr><td style={infoWindowPropTitle}>{TAPi18n.__('trip.details.endAddress')}</td><td>{z.address}</td></tr>
        <tr><td style={infoWindowPropTitle}>{TAPi18n.__('trip.details.distance')}</td><td>{Number(trip.distance).toFixed(2)} km</td></tr>
        <tr><td style={infoWindowPropTitle}>{TAPi18n.__('trip.details.speeding')}</td><td>{if trip.speeding then TAPi18n.__('general.yes') else TAPi18n.__('general.no')}</td></tr>
        <tr><td style={infoWindowPropTitle}>{TAPi18n.__('trip.details.avgSpeed')}</td><td>{Number((Number(trip.avgSpeed)).toFixed(0))} км/ч</td></tr>
        <tr><td style={infoWindowPropTitle}>{TAPi18n.__('trip.details.maxSpeed')}</td><td>{Number((Number(trip.maxSpeed)).toFixed(0))} км/ч</td></tr>
      </table>
    </div>
  render: ->
    tripUi = []
    tripDetailsUi = null
    @props.trips.forEach (trip, i) =>
      style = if trip._id is @props.tripId then selectedStyle else {padding: 10, cursor: 'pointer'}
      ref = if trip._id is @props.tripId then 'selectedRow' else null
      tripUi.push <tr ref={ref} key={i} style={style} onClick={=> @props.onTripSelected trip, false}>
        <td style=tdStyle>{i+1}</td>
        <td style=tdStyle>{format trip.startTime}</td>
        <td style=tdStyle>&#8249; {Number((Number(trip.distance)).toFixed(0))} км {if trip.speeding then speeding} &#8250;</td>
        <td style=tdStyle>{format trip.stopTime}</td>
      </tr>
      if trip._id is @props.tripId then tripDetailsUi = @renderInfoWindow trip
    unless @props.trips.length
      tripUi.push <tr key='loading'><td colSpan={3} style={textAlign: 'center'}>
        <div className="spinner"></div>
      </td></tr>
    tripListHeightDeducter = if tripDetailsUi then 300 else 151
    <div>
      <MultiTripMap trips={@props.trips} selectedTripId={@props.tripId} onTripSelected={@props.onTripSelected} />
      <div style={width: 400, height: 'calc(100vh - 61px)', float:'right', backgroundColor: 'white', paddingTop: 0}>
        <h2 style={textAlign:'center', marginTop: 15, marginBottom: 0}><small>{@props.date}</small></h2>
        <h3 style={textAlign:'center', marginTop: 0, fontSize: 20}><small>{@props.vehicle?.name} &mdash; {@props.vehicle?.licensePlate}</small></h3>
        <div style={height: "calc(100vh - #{tripListHeightDeducter}px)", overflowY: 'scroll', padding: 10}>

          <table style={color: '#222', width: '100%', fontSize: 13}>
            {if @props.trips.length
              <thead>
                <tr>
                  <th style=centeredStyle>&#35;</th>
                  <th style=centered50W>Start</th>
                  <th style=centeredStyle></th>
                  <th style=centered50W>Stop</th>
                </tr>
              </thead>
            }
            <tbody>
              {tripUi}
            </tbody>
          </table>
        </div>
        {tripDetailsUi}
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
