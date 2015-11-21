Template.fleets.helpers
  options: ->
    i18nRoot: 'fleet'
    collection: Fleets
    editItemTemplate: 'fleet'
    removeItemMethod: 'removeFleet'
    gridConfig:
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
