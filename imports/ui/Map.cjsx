React               = require 'react'
{ createContainer } = require 'meteor/react-meteor-data'

{ Map, Marker, Popup, TileLayer } = require 'react-leaflet'

position = [51.505, -0.09]

module.exports  = React.createClass
  displayName: 'Map'



  render: ->
    <Map ref='map' center={position} zoom={13}  style={height:'calc(100vh - 61px)'}>
      <TileLayer
        url='http://{s}.tile.osm.org/{z}/{x}/{y}.png'
        attribution='&copy; <a href="http://osm.org/copyright">OpenStreetMap</a> contributors'
      />
      <Marker position={position}>
        <Popup>
          <span>A pretty CSS3 popup.<br/>Easily customizable.</span>
        </Popup>
      </Marker>
    </Map>
