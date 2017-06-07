React               = require 'react'
ReactDOM            = require 'react-dom'
{ installListeners } = require './Utils.coffee'

module.exports  = React.createClass
  displayName: 'Map'

  propTypes:
    initialZoom: React.PropTypes.number
    initialCenter: React.PropTypes.object
    centerAroundCurrentLocation: React.PropTypes.bool
    onMove: React.PropTypes.func

  getDefaultProps: ->
    initialZoom: 5
    initialCenter:
      lat: 46.8029057
      lng: 11.7545206
    centerAroundCurrentLocation: false
    onMove: ->

  getInitialState: ->
    zoom: @props.initialZoom
    center: @props.initialCenter

  componentDidUpdate: (prevProps, prevState) ->
    if prevState.center isnt @state.center then @recenterMap()

  componentDidMount: ->
    console.log 'maps did mount'
    if @props.centerAroundCurrentLocation and geoloc = navigator?.geolocation
      geoloc.getCurrentPosition (pos) =>
        @setState center:
          lat: pos.coords.latitude
          lng: pos.coords.longitude

    if @google = window.google
      @loadMap()
    else console.error 'Google Maps API not loaded. Is it included in a script tag?'

  loadMap: ->
    mapRef = @refs.map
    mapDomNode =  ReactDOM.findDOMNode mapRef
    zoom = @state.zoom
    {lat, lng} = @state.center
    center = new @google.maps.LatLng lat, lng
    mapConfig = Object.assign {},
      center: center
      zoom: zoom
    @map = new @google.maps.Map mapDomNode, mapConfig
    installListeners @, @map
    @map.addListener 'dragend', (evt) => @props.onMove @map
    @forceUpdate()

  render: ->
    <div ref='map' style={@props.style}>
      Loading Google Maps...
      {@renderChildren()}
    </div>

  renderChildren: ->
    if children = @props.children
      React.Children.map children, (c) =>
        React.cloneElement c,
          map: @map
          google: @google
          mapCenter: @state.center

  recenterMap: ->
    @map?.panTo new @google.maps?.LatLng @state.center.lat, @state.center.lng
