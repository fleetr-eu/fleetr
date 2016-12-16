React       = require 'react'
IconButton  = require './IconButton.cjsx'

module.exports = React.createClass
  displayName: 'DeleteButton'

  render: ->
    <IconButton title='Delete' className='pe-7s-trash' onClick={@props.onClick} />
