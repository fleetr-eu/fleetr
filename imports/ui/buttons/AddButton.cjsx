React       = require 'react'
IconButton  = require './IconButton.cjsx'

module.exports = React.createClass
  displayName: 'AddButton'

  render: ->
    <IconButton title='New' className='pe-7s-plus' onClick={@props.onClick} />
