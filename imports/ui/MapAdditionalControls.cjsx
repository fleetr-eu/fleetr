React               = require 'react'

activeStyle = backgroundColor: '#F7F7F8'

clearStyle =
  zIndex: 10
  pointerEvents: 'auto'
  cursor: 'pointer'

module.exports = React.createClass
  displayName: 'MapAdditionalControls'

  onClick: (e) ->
    e.stopPropagation()
    return false

  render: ->
    <span>
      <ul className="nav navbar-nav navbar-left">
        <li className="dropdown">
          <a href="#" className="dropdown-toggle" data-toggle="dropdown" role="button" aria-haspopup="true" aria-expanded="false">Settings <span className="caret"></span></a>
          <ul className="dropdown-menu" onClick={(e) -> e.preventDefault();e.stopPropagation()}>
            <li><a href="#" onClick={@onClick} className="small" data-value="option1" tabIndex="-1"><input type="checkbox"/>&nbsp;Show objects</a></li>
            <li><a href="#" onClick={@onClick} className="small" data-value="option2" tabIndex="-1"><input type="checkbox"/>&nbsp;Show info points</a></li>
            <li><a href="#" onClick={@onClick} className="small" data-value="option3" tabIndex="-1"><input type="checkbox"/>&nbsp;Show vehicle names</a></li>
          </ul>
        </li>
      </ul>
      <form className="navbar-form navbar-left" action='#' style={marginBottom:0}>
        <div className="form-group">
          <input id="pac-input" type="text" className="form-control" placeholder="Enter a location..." />
          <span style=clearStyle className="form-control-clear glyphicon glyphicon-remove form-control-feedback hidden" />
        </div>
      </form>
    </span>
