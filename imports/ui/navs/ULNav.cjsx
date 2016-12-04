React       = require 'react'

module.exports = React.createClass
  displayName: 'ULNav'

  render: ->
    children = if (x = @props.children).map? then x else [x]
    <ul className="nav navbar-nav navbar-left" style={height:60}>
      {children.map (c, i) ->
        <li key=i>{c}</li>
      }
    </ul>
