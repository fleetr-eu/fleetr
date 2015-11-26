Template.vehicles.helpers
  options: ->
    i18nRoot: 'vehicles'
    collection: Vehicles
    editItemTemplate: 'vehicle'
    removeItemMethod: 'removeVehicle'
    gridConfig:
      columns: [
        id: "name"
        field: "name"
        name: "#{TAPi18n.__('vehicles.name')}"
        width:80
        sortable: true
        search: where: 'client'
      ,
        id: "licensePlate"
        field: "licensePlate"
        name: "#{TAPi18n.__('vehicles.licensePlate')}"
        width:80
        sortable: true
        search: where: 'client'
      ,
        id: "tags"
        field: "tags"
        name: "#{TAPi18n.__('vehicles.tags')}"
        width:80
        sortable: true
        search: where: 'client'
        formatter: FleetrGrid.Formatters.blazeFormatter Template.columnTags
      ]
      options:
        enableCellNavigation: true
        enableColumnReorder: false
        showHeaderRow: true
        explicitInitialization: true
        forceFitColumns: true
      cursor: Vehicles.find()
