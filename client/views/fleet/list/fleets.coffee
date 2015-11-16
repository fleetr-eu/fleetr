Template.fleets.onRendered ->
  Session.set 'selectedFleetId', null

options =
  backdrop: 'static'
  keyboard: false

Template.fleets.events
  'click .deleteFleet': (e, t) ->
    data =
      title: -> TAPi18n.__ 'fleet.title'
      message: -> TAPi18n.__ 'fleet.deleteMessage'
      action: ->
        Meteor.call 'removeFleet', Session.get('selectedFleetId'), ->
          Meteor.defer ->
            Session.set 'selectedFleetId', t.grid.data[t.row]?._id
    Modal.show 'confirmDelete', data, options
  'rowsSelected': (e, t) ->
    [t.grid, t.row] = [e.fleetrGrid, e.rowIndex]
    Session.set 'selectedFleetId', t.grid.data[t.row]._id
  'click .edit-fleet': -> Modal.show 'fleet', {doc: Fleets.findOne(_id: Session.get('selectedFleetId'))}, options
  'click .add-fleet': -> Modal.show 'fleet', {}, options

Template.fleets.helpers
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
      search: where: 'client',  
    ]
    options:
      enableCellNavigation: true
      enableColumnReorder: false
      showHeaderRow: true
      explicitInitialization: true
      forceFitColumns: true
    cursor: Fleets.find {},
      transform: (doc) -> _.extend doc,
        groupName: FleetGroups.findOne(_id: doc.parent)?.name

