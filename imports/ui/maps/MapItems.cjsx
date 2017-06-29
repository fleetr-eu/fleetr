React   = require 'react'

module.exports  = React.createClass
  displayName: 'MapItems'

  render: ->
    <span>{@renderChildren()}</span>

  renderChildren: ->
    if children = @props.children
      React.Children.map children, (c) =>
        if c then React.cloneElement c,
          map: @props.map
          google: @props.google
          marker: @state?.marker
