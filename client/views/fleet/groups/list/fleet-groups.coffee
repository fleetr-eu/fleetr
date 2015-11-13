Template.fleetGroups.onRendered ->
  Session.set 'selectedFleetGroupId', null

Template.fleetGroups.events
  'click .deleteFleetGroup': ->
    Meteor.call 'removeFleetGroup', Session.get('selectedFleetGroupId')
    Session.set 'selectedFleetGroupId', null
  'rowsSelected': (e, t) ->
    Session.set 'selectedFleetGroupId', e.fleetrGrid.data[e.rowIndex]._id

Template.fleetGroups.helpers
  selectedFleetGroupId: -> Session.get('selectedFleetGroupId')
  fleetGroupsConfig: ->
    cursor: FleetGroups.find()
    columns: [
      id: "name"
      field: "name"
      name: "#{TAPi18n.__('fleetGroups.name')}"
      width:80
      sortable: true
      search: where: 'client'
    ,
      id: "description"
      field: "description"
      name: "#{TAPi18n.__('fleetGroups.description')}"
      width:160
      sortable: true
      search: where: 'client'
    ]
    options:
      enableCellNavigation: true
      enableColumnReorder: false
      showHeaderRow: true
      explicitInitialization: true
      forceFitColumns: true
