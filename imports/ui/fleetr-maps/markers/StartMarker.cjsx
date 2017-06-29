React   = require 'react'
Marker  = require '../../maps/Marker.cjsx'

module.exports  = React.createClass
  displayName: 'StartMarker'

  render: ->
    <Marker {...@props}
      title='Start'
      icon='/images/icons/start.png' />
