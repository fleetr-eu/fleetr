React               = require 'react'
ULNav               = require './navs/ULNav.cjsx'
IconButton          = require './buttons/IconButton.cjsx'

activeStyle = backgroundColor: '#F7F7F8'

clearStyle =
  zIndex: 10
  pointerEvents: 'auto'
  cursor: 'pointer'

module.exports = React.createClass
  displayName: 'MapAdditionalControls'

  filterClicked: (e) ->
    Session.set 'showFilterBox', not Session.get 'showFilterBox'

  render: ->
    <ULNav>
      <IconButton title='Filter' className='pe-7s-car' onClick={@filterClicked} />
      <div className="form-group" style={paddingTop:10, paddingLeft:10}>
        <input id="pac-input" type="text" className="form-control" placeholder="Enter a location..." />
        <span style=clearStyle className="form-control-clear glyphicon glyphicon-remove form-control-feedback hidden" />
      </div>
    </ULNav>
