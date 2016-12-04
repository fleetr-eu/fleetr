React               = require 'react'
ULNav               = require './navs/ULNav.cjsx'

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
    <ULNav>
      <div className="form-group" style={paddingTop:10, paddingLeft:10}>
        <input id="pac-input" type="text" className="form-control" placeholder="Enter a location..." />
        <span style=clearStyle className="form-control-clear glyphicon glyphicon-remove form-control-feedback hidden" />
      </div>
    </ULNav>


# <ul className="nav navbar-nav navbar-left">
#   <li className="dropdown">
#     <a href="#" className="dropdown-toggle" data-toggle="dropdown" role="button" aria-haspopup="true" aria-expanded="false">Settings <span className="caret"></span></a>
#     <ul className="dropdown-menu" onClick={(e) -> e.preventDefault();e.stopPropagation()}>
#       <li><a href="#" onClick={@onClick} className="small" data-value="option1" tabIndex="-1"><input type="checkbox"/>&nbsp;Show objects</a></li>
#       <li><a href="#" onClick={@onClick} className="small" data-value="option2" tabIndex="-1"><input type="checkbox"/>&nbsp;Show info points</a></li>
#       <li><a href="#" onClick={@onClick} className="small" data-value="option3" tabIndex="-1"><input type="checkbox"/>&nbsp;Show vehicle names</a></li>
#     </ul>
#   </li>
# </ul>
