React   = require 'react'
equal   = require('deep-equal')
{ installListeners } = require './Utils.coffee'

module.exports  = React.createClass
  displayName: 'Polyline'

  propTypes:
    position: React.PropTypes.object
    google: React.PropTypes.object
    map: React.PropTypes.object

  componentDidUpdate: (prevProps) ->
    if (@props.map isnt prevProps.map) or (not equal(@props.path, prevProps.path))
      @renderPath()

  componentWillMount: ->
    if @props.map? and @props.path? then @renderPath()

  componentWillUnmount: ->
    @state?.polyline?.setMap null

  renderPath: ->
    if @state?.polyline then @state.polyline.setMap null # remove existing polyline, if any
    {path, google, map} = @props
    options =
      icons: [
        icon:
          path: google.maps.SymbolPath.FORWARD_OPEN_ARROW
          strokeWeight: 2
          strokeColor: 'white'
          scale: 1
        offset: '30px'
        repeat: '30px'
      ]
      map: map
      path: path
      strokeColor: 'blue'
      strokeOpacity: 0.6
      strokeWeight: 7
    polyline = new google.maps.Polyline options
    bounds = new google.maps.LatLngBounds()
    path.forEach (coord) -> console.log 'extend bounds', coord; bounds.extend(new google.maps.LatLng coord.lat, coord.lng)
    path.forEach (coord) -> console.log 'extend bounds', coord; bounds.extend(new google.maps.LatLng coord.lat, coord.lng)
    console.log 'bounds', bounds
    map.fitBounds bounds
    installListeners @, polyline
    @setState polyline: polyline

  render: ->
    <span>{@renderChildren()}</span>

  renderChildren: ->
    if children = @props.children
      React.Children.map children, (c) =>
        React.cloneElement c,
          map: @props.map
          google: @props.google
          polyline: @state?.polyline
