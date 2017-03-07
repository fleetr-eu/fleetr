Template.fleets.helpers
  options: ->
    i18nRoot: 'fleet'
    collection: Fleets
    editItemTemplate: 'fleet'
    removeItemMethod: 'removeFleet'
    gridConfig:
      columns: [
        id: "group"
        field: "groupName"
        name: "#{TAPi18n.__('fleet.parent')}"
        width:120
        sortable: true
        search: where: 'client'
        groupable:
          aggregators: []
      ,
        id: "fleet"
        field: "name"
        name: "#{TAPi18n.__('fleet.name')}"
        width:120
        sortable: true
        search: where: 'client'
      ,
        id: "description"
        field: "description"
        name: "#{TAPi18n.__('fleet.description')}"
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
          groupName: FleetGroups.findOne(_id: doc.parent)?.name
      customize: (grid) ->
        grid.addGroupBy 'groupName', TAPi18n.__('fleet.parent'), []
