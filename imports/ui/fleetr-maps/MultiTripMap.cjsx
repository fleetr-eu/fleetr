React               = require 'react'
Map                 = require '../maps/Map.cjsx'
MapItems            = require '../maps/MapItems.cjsx'
StartMarker         = require '../fleetr-maps/markers/StartMarker.cjsx'
StopMarker          = require '../fleetr-maps/markers/StopMarker.cjsx'
RoutePolyline       = require '../fleetr-maps/RoutePolyline.cjsx'

module.exports = MultiTripMap = React.createClass
  displayName: 'MultiTripMap'

  render: ->
    console.log 'MultiTripMap', @props
    <Map style={height:'calc(100vh - 61px)', width:'calc(100% - 400px)', float: 'left'}>
      {@props.tripsPoints.map (points, i) =>
        [start, ..., stop] = points
        selected = start.attributes.trip is @props.selectedTripId
        <MapItems key={i}>
          {if selected
            <MapItems>
              <StartMarker position={start}/>
              <StopMarker position={stop}/>
            </MapItems>
          }
          <RoutePolyline points={points} selected={selected} />
        </MapItems>
      }
    </Map>
