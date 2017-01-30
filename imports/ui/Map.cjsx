React               = require 'react'
{ createContainer } = require 'meteor/react-meteor-data'

GoogleMap = (require 'google-map-react').default;

position = [51.505, -0.09]

defaultProps =
  center: {lat: 59.938043, lng: 30.337157}
  zoom: 9
  greatPlaceCoords: {lat: 59.724465, lng: 30.080121}

MyMarker = React.createClass
  displayName: 'FleetrMarker'

  render: ->
    <div style={padding:5, backgroundColor:'lightGrey', width:100}>Im a marker at {@props.lat}:{@props.lng}</div>

module.exports  = React.createClass
  displayName: 'FleetrMap'

  render: ->
    console.log GoogleMap
    <GoogleMap defaultCenter={defaultProps.center} defaultZoom={defaultProps.zoom} style={height:'calc(100vh - 61px)'}>
      <MyMarker style={padding:5} lat={59.955413} lng={30.337844} />
    </GoogleMap>
