React   = require 'react'
_       = require 'lodash'
equal   = require('deep-equal')
{ installListeners } = require './Utils.coffee'

module.exports  = React.createClass
  displayName: 'Polyline'

  propTypes:
    position: React.PropTypes.object
    google: React.PropTypes.object
    map: React.PropTypes.object

  componentDidUpdate: (prevProps) ->
    if (@props.map isnt prevProps.map) or (not equal(@props.path, prevProps.path)) or (not equal(@props.options, prevProps.options))
      @renderPath()

  componentWillMount: ->
    if @props.map? and @props.path? then @renderPath()

  componentWillUnmount: ->
    @state?.polyline?.setMap null

  renderPath: ->
    if @state?.polyline then @state.polyline.setMap null # remove existing polyline, if any
    {path, google, map, options} = @props
    opts =
      map: map
      path: path
    polyline = new google.maps.Polyline _.extend opts, options
    bounds = new google.maps.LatLngBounds()
    path.forEach (coord) -> bounds.extend(new google.maps.LatLng coord.lat, coord.lng)
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
