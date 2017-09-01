React               = require 'react'
_                   = require 'lodash'
Map                 = require '../maps/Map.cjsx'
MapItems            = require '../maps/MapItems.cjsx'
MapLabel            = require '../maps/MapLabel.cjsx'
CircleMarker        = require '../maps/CircleMarker.cjsx'
StartMarker         = require '../fleetr-maps/markers/StartMarker.cjsx'
StopMarker          = require '../fleetr-maps/markers/StopMarker.cjsx'
RoutePolyline       = require '../fleetr-maps/RoutePolyline.cjsx'

module.exports = MultiTripMap = React.createClass
  displayName: 'MultiTripMap'

  render: ->
    points = _.union.apply({}, @props.trips.map (t) -> t.logbook)
    <Map style={height:'calc(100vh - 61px)', width:'calc(100% - 400px)', float: 'left'} fitBounds={points}>
      {@props.trips.map (trip, i) =>
        [start, ..., stop] = trip.logbook
        selected = trip._id is @props.selectedTripId
        <MapItems key={i}>
          <MapLabel position={start} label={i} />
          {if selected
            <MapItems>
              <StartMarker position={start}/>
              <StopMarker position={stop}/>
            </MapItems>
          }
          <RoutePolyline points={trip.logbook} selected={selected} onClick={=> @props.onTripSelected trip} />

        </MapItems>
      }
    </Map>
