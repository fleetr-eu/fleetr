React               = require 'react'
{ createContainer } = require 'meteor/react-meteor-data'

ULNav        = require './ULNav.cjsx'
IconButton   = require '../buttons/IconButton.cjsx'
AddButton    = require '../buttons/AddButton.cjsx'
EditButton   = require '../buttons/EditButton.cjsx'
DeleteButton = require '../buttons/DeleteButton.cjsx'

clearStyle =
  zIndex: 10
  pointerEvents: 'auto'
  cursor: 'pointer'

GeofencesNav = React.createClass
  displayName: 'GeofencesNav'

  addButtonClicked: ->
    Session.set 'selectedGeofenceId', null
    Session.set 'editGeofence', false
    Session.set 'addGeofence', true
    Session.set 'showGfList', true

  editButtonClicked: ->
    Session.set 'addGeofence', false
    Session.set 'editGeofence', true
    Session.set 'showGfList', true

  deleteButtonClicked: ->
    Modal.show 'confirmDelete',
      title: 'geofences.title'
      message: 'geofences.deleteMessage'
      action: ->
        Meteor.call 'removeGeofence', Session.get('selectedGeofenceId')
        Session.set 'selectedGeofenceId', null

  listObjectsClicked: ->
    Session.set 'showGfList', not Session.get('showGfList')

  render: ->
    <ULNav>
      <AddButton onClick={@addButtonClicked} />
      {if @props.selectedGeofenceId
        <EditButton onClick={@editButtonClicked} />
      }
      {if @props.selectedGeofenceId
        <DeleteButton onClick={@deleteButtonClicked} />
      }
      <IconButton title='List objects' className='pe-7s-home' onClick={@listObjectsClicked} />
      <div className="form-group" style={paddingTop:10, paddingLeft:10}>
        <input id="pac-input" type="text" className="form-control" placeholder="Enter a location..." />
        <span style=clearStyle className="form-control-clear glyphicon glyphicon-remove form-control-feedback hidden" />
      </div>
    </ULNav>

module.exports = createContainer (props) ->
  selectedGeofenceId: Session.get('selectedGeofenceId')
, GeofencesNav
