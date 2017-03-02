React = require 'react'
Map   = require './Map.cjsx'

module.exports  = React.createClass
  displayName: 'MapContainer'

  render: ->
    <Map />
