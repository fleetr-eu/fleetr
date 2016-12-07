React       = require 'react'

module.exports = React.createClass
  displayName: 'TextButton'

  render: ->
    <a href="#" onClick={@props.onClick} style={padding:'5px'} title={@props.title}>
      <span style={fontSize:'20px', fontWeight: 200}>{@props.title}</span>
    </a>
