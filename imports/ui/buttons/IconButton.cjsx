React       = require 'react'

module.exports = React.createClass
  displayName: 'IconButton'

  render: ->
    <a href="#" onClick={@props.onClick} style={padding:'5px'} title={@props.title}>
      <i className={@props.className} style={fontSize:'30px'}></i>
    </a>
