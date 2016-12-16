React               = require 'react'
CrudButtons         = require '/imports/ui/CrudButtons.cjsx'

activeStyle = backgroundColor: '#F7F7F8'

module.exports = React.createClass
  displayName: 'FleetsMenu'

  render: ->
    <span>
      <CrudButtons editItemTemplate='fleet' i18nRoot='fleet' collection=Fleets removeItemMethod='removeFleet'>
        <li style=activeStyle><a href={Router.path 'listFleets'}>Fleets</a></li>
        <li><a className='active' href={Router.path 'listFleetGroups'}>Fleet Groups</a></li>
      </CrudButtons>
    </span>
