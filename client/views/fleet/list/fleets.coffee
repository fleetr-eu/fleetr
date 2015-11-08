Template.fleets.created = ->
  Session.setDefault 'fleetFilter', ''

Template.fleets.events
  'click .deleteFleet': ->
    Meteor.call 'removeFleet', Session.get('selectedFleetId')
    Session.set 'selectedFleetId', null
  'rowsSelected': (e, t) ->
    console.log e
    Session.set 'selectedFleetId', e.fleetrGrid.data[e.rowIndex]._id

Template.fleets.helpers
  fleets: -> Fleets.findFiltered Session.get('fleetFilter'), ['name', 'description']
  selectedFleetId: -> Session.get('selectedFleetId')


# TODO: Everything
# Template.fleetTableRow.helpers
#   active: -> if @_id == Session.get('selectedFleetId') then 'active' else ''
#   group: -> FleetGroups.findOne(_id: @parent).name
#
# Template.fleetTableRow.events
#   # 'click tr': -> Session.set 'selectedFleetId', @_id


Template.fleets.helpers
  fleetsConfig: ->
    columns: [
      id: "fleet"
      field: "name"
      name: "Fleet"
      width:120
      sortable: true
      search: where: 'client'
    ,
      id: "description"
      field: "description"
      name: "Description"
      width:120
      sortable: true
      search: where: 'client'
    ,
      id: "group"
      field: "parent"
      name: "Group"
      width:120
      sortable: true
      search: where: 'client'
    ]
    options:
      enableCellNavigation: true
      enableColumnReorder: false
      showHeaderRow: true
      explicitInitialization: true
      forceFitColumns: true
    cursor: Fleets.find()
