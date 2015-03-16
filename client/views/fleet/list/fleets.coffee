Template.fleets.created = ->
  Session.setDefault 'fleetFilter', ''

Template.fleets.events
  'click .deleteFleet': ->
    Meteor.call 'removeFleet', Session.get('selectedFleetId')
    Session.set 'selectedFleetId', null

Template.fleets.helpers
  fleets: -> Fleets.findFiltered 'fleetFilter', ['name', 'description']
  selectedFleetId: -> Session.get('selectedFleetId')

Template.fleetTableRow.helpers
  active: -> if @_id == Session.get('selectedFleetId') then 'active' else ''
  group: -> FleetGroups.findOne(_id: @parent).name

Template.fleetTableRow.events
  'click tr': -> Session.set 'selectedFleetId', @_id
