Template.drivers.onRendered ->
  Session.set 'selectedDriverId', null

Template.drivers.events
  'click .deleteDriver': ->
    Meteor.call 'removeDriver', Session.get('selectedDriverId')
    Session.set 'selectedDriverId', null
  'rowsSelected': (e, t) ->
    Session.set 'selectedDriverId', e.fleetrGrid.data[e.rowIndex]._id

Template.drivers.helpers
  selectedDriverId: -> Session.get('selectedDriverId')
  driversConfig: ->
    cursor: Drivers.find()
    columns: [
      id: "firstName"
      field: "firstName"
      name: "#{TAPi18n.__('drivers.firstName')}"
      width:80
      sortable: true
      search: where: 'client'
    ,
      id: "lastName"
      field: "name"
      name: "#{TAPi18n.__('drivers.name')}"
      width:80
      sortable: true
      search: where: 'client'
    ]
    options:
      enableCellNavigation: true
      enableColumnReorder: false
      showHeaderRow: true
      explicitInitialization: true
      forceFitColumns: true
