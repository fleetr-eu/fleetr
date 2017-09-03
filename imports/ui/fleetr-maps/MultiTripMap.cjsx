React               = require 'react'
_                   = require 'lodash'
Map                 = require '../maps/Map.cjsx'
MapItems            = require '../maps/MapItems.cjsx'
Marker              = require '../maps/Marker.cjsx'
RoutePolyline       = require '../fleetr-maps/RoutePolyline.cjsx'

module.exports = MultiTripMap = React.createClass
  displayName: 'MultiTripMap'

  render: ->
    points = _.union.apply({}, @props.trips.map (t) -> t.logbook)
    <Map style={height:'calc(100vh - 61px)', width:'calc(100% - 400px)', float: 'left'} fitBounds={points}>
      {@props.trips.map (trip, i) =>
        [start, ..., stop] = trip.logbook
        selected = trip._id is @props.selectedTripId
        color = if selected then '25B477|000' else '737372|FFFFFF'
        <MapItems key={i}>
          <Marker position={start} icon="https://chart.googleapis.com/chart?chst=d_map_pin_letter&chld=#{i+1}|#{color}" selected={selected} onClick={=> @props.onTripSelected trip} />
          <RoutePolyline points={trip.logbook} selected={selected} onClick={=> @props.onTripSelected trip} />
        </MapItems>
      }
    </Map>
