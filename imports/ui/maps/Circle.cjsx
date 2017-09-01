React   = require 'react'
equal   = require('deep-equal')
{ installListeners } = require './Utils.coffee'

module.exports  = React.createClass
  displayName: 'Circle'

  propTypes:
    position: React.PropTypes.object
    google: React.PropTypes.object
    map: React.PropTypes.object

  componentDidUpdate: (prevProps) ->
    if (@props.map isnt prevProps.map) or (not equal(@props.position, prevProps.position))
      @renderMarker()

  componentWillMount: ->
    if @props.map? and (@props.position?) then @renderMarker()

  componentWillUnmount: ->
    @state?.circle?.setMap null

  renderMarker: ->
    if @state?.circle then @state.circle.setMap null # remove existing marker, if any
    {position, google, map} = @props
    pos = position

    circle = new google.maps.Circle
      strokeColor: '#FF0000'
      strokeOpacity: 0.8
      strokeWeight: 2
      fillColor: '#FF0000'
      fillOpacity: 0.35
      map: map
      center: new google.maps.LatLng pos.lat, pos.lng
      radius: 100

    installListeners @, circle
    @setState circle: circle

  render: ->
    <span>{@renderChildren()}</span>

  renderChildren: ->
    if children = @props.children
      React.Children.map children, (c) =>
        React.cloneElement c,
          map: @props.map
          google: @props.google
          marker: @state?.marker
