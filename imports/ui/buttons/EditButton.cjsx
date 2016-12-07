React       = require 'react'
IconButton  = require './IconButton.cjsx'

module.exports = React.createClass
  displayName: 'EditButton'

  render: ->
    <IconButton title='Edit' className='pe-7s-pen' onClick={@props.onClick} />
