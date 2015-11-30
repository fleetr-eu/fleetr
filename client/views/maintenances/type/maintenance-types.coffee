Template.maintenanceTypes.helpers
  options: ->
    i18nRoot: 'maintenanceTypes'
    collection: MaintenanceTypes
    editItemTemplate: 'maintenanceType'
    removeItemMethod: 'removeMaintenanceype'
    gridConfig:
      cursor: MaintenanceTypes.find()
      columns: [
        id: "name"
        field: "name"
        name: "#{TAPi18n.__('maintenanceTypes.name')}"
        width:120
        sortable: true
        search: where: 'client'
      ,
        id: "description"
        field: "description"
        name: "#{TAPi18n.__('maintenanceTypes.description')}"
        width:200
        sortable: true
        search: where: 'client'
      ,
        id: "nextMaintenanceMonths"
        field: "nextMaintenanceMonths"
        name: "#{TAPi18n.__('maintenanceTypes.nextMaintenanceMonths')}"
        width:200
        sortable: true
        search: where: 'client'
      ,
        id: "nextMaintenanceKMs"
        field: "nextMaintenanceKMs"
        name: "#{TAPi18n.__('maintenanceTypes.nextMaintenanceKMs')}"
        width:200
        sortable: true
        search: where: 'client'
      ,
        id: "nextMaintenanceEngineHours"
        field: "nextMaintenanceEngineHours"
        name: "#{TAPi18n.__('maintenanceTypes.nextMaintenanceEngineHours')}"
        width:200
        sortable: true
        search: where: 'client'      
      ]
      options:
        enableCellNavigation: true
        enableColumnReorder: false
        showHeaderRow: true
        explicitInitialization: true
        forceFitColumns: true
