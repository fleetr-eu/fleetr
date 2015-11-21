Template.fleetGroups.onRendered ->
  Session.set 'selectedFleetGroupId', null

Template.fleetGroups.events
  'click .delete-fleet-group': (e, t) ->
    data =
      title: -> TAPi18n.__ 'fleetGroup.title'
      message: -> TAPi18n.__ 'fleetGroup.deleteMessage'
      action: ->
        Meteor.call 'removeFleetGroup', Session.get('selectedFleetGroupId'), ->
          Meteor.defer ->
            Session.set 'selectedFleetGroupId', t.grid.data[t.row]?._id
    Modal.show 'confirmDelete', data
  'rowsSelected': (e, t) ->
    [t.grid, t.row] = [e.fleetrGrid, e.rowIndex]
    Session.set 'selectedFleetGroupId', t.grid.data[t.row]._id
  'click .edit-fleet-group': -> ModalForm.show 'fleetGroup',
    doc: FleetGroups.findOne(_id: Session.get('selectedFleetGroupId'))
  'click .add-fleet-group': -> ModalForm.show 'fleetGroup'

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
