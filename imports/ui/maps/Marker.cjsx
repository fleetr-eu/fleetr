React   = require 'react'

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
    latlng = new google.maps.LatLng pos.lat, pos.lng
    @setState marker: new google.maps.Marker map: map, position: latlng

  render: ->
    <span>{@renderChildren()}</span>

  renderChildren: ->
    if children = @props.children
      React.Children.map children, (c) =>
        React.cloneElement c,
          map: @props.map
          google: @props.google
          marker: @state?.marker
