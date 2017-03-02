React               = require 'react'
ReactDOM            = require 'react-dom'

module.exports  = React.createClass
  displayName: 'Map'

  propTypes:
    initialZoom: React.PropTypes.number
    initialCenter: React.PropTypes.object

  getDefaultProps: ->
    initialZoom: 5
    initialCenter:
      lat: 46.8029057
      lng: 11.7545206

  getInitialState: ->
    zoom: @props.initialZoom
    center: @props.initialCenter

  componentDidUpdate: (prevProps, prevState) ->
    if window.google?.maps? then @loadMap()

  componentDidMount: ->
    if window.google?.maps?
      @loadMap()
    else console.error 'Google Maps API not loaded. Is it included in a script tag?'

  loadMap: ->
    maps = window.google.maps
    mapRef = @refs.map
    mapDomNode =  ReactDOM.findDOMNode mapRef
    zoom = @state.zoom
    {lat, lng} = @state.center
    center = new maps.LatLng lat, lng
    mapConfig = Object.assign {},
      center: center
      zoom: zoom
    @map = new maps.Map mapDomNode, mapConfig

  render: ->
    <div ref='map' style={width:'100vw', height:'100vh'}>
      Loading Google Maps...
    </div>
