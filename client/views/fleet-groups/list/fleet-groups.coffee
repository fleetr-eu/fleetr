Template.fleetGroups.created = ->
  Session.setDefault 'fleetGroupFilter', ''

Template.fleetGroups.events
  'click .deleteFleetGroup': ->
    Meteor.call 'removeFleetGroup', Session.get('selectedFleetGroupId')
    Session.set 'selectedFleetGroupId', null

Template.fleetGroups.helpers
  fleetGroups: -> FleetGroups.findFiltered 'fleetGroupFilter', ['name', 'description']
  selectedFleetGroupId: -> Session.get('selectedFleetGroupId')

Template.fleetGroupTableRow.helpers
  active: -> if @_id == Session.get('selectedFleetGroupId') then 'active' else ''

Template.fleetGroupTableRow.events
  'click tr': -> Session.set 'selectedFleetGroupId', @_id
