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
      field: "groupName"
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
    cursor: Fleets.find {},
      transform: (doc) -> _.extend doc,
        groupName: FleetGroups.findOne(_id: doc.parent).name
