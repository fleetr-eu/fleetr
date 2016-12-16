React               = require 'react'
{ createContainer } = require 'meteor/react-meteor-data'

ULNav        = require './ULNav.cjsx'
IconButton   = require '../buttons/IconButton.cjsx'

module.exports = React.createClass
  displayName: 'VehiclesLogbookNav'

  filterClicked: ->
    Session.set 'showFilterBox', not Session.get 'showFilterBox'

  render: ->
    <ULNav>
      <IconButton title='Filter' className='pe-7s-filter' onClick={@filterClicked} />
    </ULNav>
