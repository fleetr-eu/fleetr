Template.maintenances.onRendered ->
  Template.maintenance.helpers
    vehicleId: => @data.vehicleId

Template.maintenances.helpers
  options: ->
    i18nRoot: 'maintenances'
    collection: Maintenances
    editItemTemplate: 'maintenance'
    removeItemMethod: 'removeMaintenance'
    gridConfig:
      columns: [
        id: "maintenanceTypeName"
        field: "maintenanceTypeName"
        name: "#{TAPi18n.__('maintenances.maintenanceType')}"
        width:80
        sortable: true
        search: where: 'client'
      ,
        id: "maintenanceDate"
        field: "maintenanceDate"
        name: "#{TAPi18n.__('maintenances.maintenanceDate')}"
        width:50
        sortable: true
        search: where: 'client'
        formatter: FleetrGrid.Formatters.dateFormatter
      ,
        id: "odometer"
        field: "odometer"
        name: "#{TAPi18n.__('maintenances.odometer')}"
        width:50
        sortable: true
        search: where: 'client'
        align: "right"
      ,  
        id: "nextKm"
        field: "nextKm"
        name: "#{TAPi18n.__('maintenances.nextKm')}"
        width:50
        sortable: true
        search: where: 'client' 
        align: "right"
      ,
        id: "engineHours"
        field: "engineHours"
        name: "#{TAPi18n.__('maintenances.engineHours')}"
        width:50
        sortable: true
        search: where: 'client'
        align: "right"
      ,
        id: "nextMaintenanceDate"
        field: "nextMaintenanceDate"
        name: "#{TAPi18n.__('maintenances.nextMaintenanceDate')}"
        width:50
        sortable: true
        search: where: 'client'
        formatter: FleetrGrid.Formatters.dateFormatter
      ,
        id: "nextMaintenanceOdometer"
        field: "nextMaintenanceOdometer"
        name: "#{TAPi18n.__('maintenances.nextMaintenanceOdometer')}"
        width:50
        sortable: true
        search: where: 'client'
        align: "right"
      ,
        id: "nextMaintenanceEngineHours"
        field: "nextMaintenanceEngineHours"
        name: "#{TAPi18n.__('maintenances.nextMaintenanceEngineHours')}"
        width:50
        sortable: true
        search: where: 'client'  
        align: "right"  
      ]
      options:
        enableCellNavigation: true
        enableColumnReorder: false
        showHeaderRow: true
        explicitInitialization: true
        forceFitColumns: true
      cursor: Maintenances.find vehicle:@vehicleId,
        transform: (doc) -> _.extend doc,
            maintenanceTypeName: MaintenanceTypes.findOne(_id: doc.maintenanceType)?.name
            nextKm: doc.nextMaintenanceOdometer-doc.odometer

