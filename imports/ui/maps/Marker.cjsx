React   = require 'react'
{ installListeners } = require './Utils.coffee'

module.exports  = React.createClass
  displayName: 'Marker'

  propTypes:
    position: React.PropTypes.object
    google: React.PropTypes.object
    map: React.PropTypes.object

  componentDidUpdate: (prevProps) ->
    if (@props.map isnt prevProps.map) or (@props.position isnt prevProps.position) or (@props.mapCenter isnt prevProps.mapCenter)
      @renderMarker()

  componentWillUnmount: ->
    @state?.marker?.setMap null

  renderMarker: ->
    if @state?.marker then @state.marker.setMap null # remove existing marker, if any
    {position, mapCenter, google, map} = @props
    pos = position or mapCenter
    options =
      map: map
      position: new google.maps.LatLng pos.lat, pos.lng
      title: @props.title
    marker = new google.maps.Marker options
    installListeners @, marker
    @setState marker: marker

  render: ->
    <span>{@renderChildren()}</span>

  renderChildren: ->
    if children = @props.children
      React.Children.map children, (c) =>
        React.cloneElement c,
          map: @props.map
          google: @props.google
          marker: @state?.marker
