React               = require 'react'
_                   = require 'lodash'
Map                 = require '../maps/Map.cjsx'
MapItems            = require '../maps/MapItems.cjsx'
StartMarker         = require '../fleetr-maps/markers/StartMarker.cjsx'
StopMarker          = require '../fleetr-maps/markers/StopMarker.cjsx'
RoutePolyline       = require '../fleetr-maps/RoutePolyline.cjsx'

module.exports = MultiTripMap = React.createClass
  displayName: 'MultiTripMap'

  render: ->
    bounds = new google.maps.LatLngBounds()
    points = _.union.apply({}, @props.trips.map (t) -> t.logbook).forEach (point) -> bounds.extend(new google.maps.LatLng point.lat, point.lng)
    <Map style={height:'calc(100vh - 61px)', width:'calc(100% - 400px)', float: 'left'} fitBounds={bounds}>
      {@props.trips.map (trip, i) =>
        [start, ..., stop] = trip.logbook
        selected = trip._id is @props.selectedTripId
        <MapItems key={i}>
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
