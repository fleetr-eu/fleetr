React               = require 'react'
{ createContainer } = require 'meteor/react-meteor-data'

ULNav        = require './ULNav.cjsx'
IconButton   = require '../buttons/IconButton.cjsx'
TextButton   = require '../buttons/TextButton.cjsx'

module.exports = React.createClass
  displayName: 'ImportExpensesNav'

  importClicked: ->
    Session.set 'showFilterBox', not Session.get 'showFilterBox'

  clearClicked: ->


  render: ->
    <ULNav>
      <IconButton title='Import' className='pe-7s-cloud-upload' onClick={@importClicked} />
      <TextButton title='Clear' onClick={@clearClicked} />
    </ULNav>
