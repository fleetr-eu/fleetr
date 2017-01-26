React               = require 'react'
{ createContainer } = require 'meteor/react-meteor-data'

{ Map, Marker, Popup, TileLayer } = require 'react-leaflet'

position = [51.505, -0.09]

module.exports  = React.createClass
  displayName: 'Map'

  render: ->
    <Map ref='map' center={position} zoom={13}  style={height:'calc(100vh - 61px)'}>
      <TileLayer
        url='http://stamen-tiles-{s}.a.ssl.fastly.net/toner-lite/{z}/{x}/{y}.{ext}'
        attribution='Map tiles by <a href="http://stamen.com">Stamen Design</a>, <a href="http://creativecommons.org/licenses/by/3.0">CC BY 3.0</a> &mdash; Map data &copy; <a href="http://www.openstreetmap.org/copyright">OpenStreetMap</a>'
      	minZoom=0
      	maxZoom=20
      	ext='png'
      />
      <Marker position={position}>
        <Popup>
          <span>A pretty CSS3 popup.<br/>Easily customizable.</span>
        </Popup>
      </Marker>
    </Map>
