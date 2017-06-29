React   = require 'react'
Marker  = require '../../maps/Marker.cjsx'

module.exports  = React.createClass
  displayName: 'StopMarker'

  render: ->
    <Marker {...@props}
      title='Stop'
      icon='/images/icons/finish.png' />
