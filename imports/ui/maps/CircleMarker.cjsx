React   = require 'react'
Marker  = require './Marker.cjsx'

module.exports  = React.createClass
  displayName: 'CircleMarker'

  render: ->
    icon =
      path: @props.google?.maps.SymbolPath.CIRCLE
      strokeWeight: 2
      strokeColor: '#3F3F3F'
      fillColor: '#FFFFFF'
      fillOpacity: 0.9
      strokeOpacity: 0.8
      scale: 10
    <Marker {...@props}
      icon={icon} />
