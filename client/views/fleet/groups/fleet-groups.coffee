Template.fleetGroups.helpers
  options: ->
    i18nRoot: 'fleetGroups'
    collection: FleetGroups
    editItemTemplate: 'fleetGroup'
    removeItemMethod: 'removeFleetGroup'
    gridConfig:
      cursor: FleetGroups.find()
      columns: [
        id: "name"
        field: "name"
        name: TAPi18n.__('fleetGroups.name')
        width:80
        sortable: true
        search: where: 'client'
      ,
        id: "description"
        field: "description"
        name: TAPi18n.__('fleetGroups.description')
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
