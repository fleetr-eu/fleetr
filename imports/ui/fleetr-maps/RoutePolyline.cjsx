React    = require 'react'
Polyline = require '../maps/Polyline.cjsx'

module.exports  = React.createClass
  displayName: 'RoutePolyline'

  getOptions: ->
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
      strokeColor: 'blue'
      strokeOpacity: 0.6
      strokeWeight: 7

  render: ->
    <Polyline options={@getOptions()} {...@props} />
