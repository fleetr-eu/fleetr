Template.maintenances.onRendered ->
  vehicleId = @data.vehicleId
  Template.maintenance.onRendered ->
    @vehicleId = vehicleId
  Template.maintenance.helpers
    vehicleId: vehicleId

Template.maintenances.helpers
  vehicleName: ->
    Vehicles.findOne(_id: @vehicleId)?.displayName()
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
        width:100
        sortable: true
        search: where: 'client'
      ,
        id: "maintenanceDate"
        field: "maintenanceDate"
        name: "#{TAPi18n.__('maintenances.maintenanceDate')}"
        width:40
        sortable: true
        search: where: 'client'
        formatter: FleetrGrid.Formatters.dateFormatter
      ,
        id: "odometer"
        field: "odometer"
        name: "#{TAPi18n.__('maintenances.odometer')}"
        width:40
        align : "right"
        sortable: true
        search: where: 'client'
        align: "right"
      ,
        id: "nextKm"
        field: "nextKm"
        name: "#{TAPi18n.__('maintenances.nextKm')}"
        width:40
        sortable: true
        align : "right"
        search: where: 'client'
        align: "right"
      ,
        id: "engineHours"
        field: "engineHours"
        name: "#{TAPi18n.__('maintenances.engineHours')}"
        width:40
        sortable: true
        align : "right"
        hidden: true
        search: where: 'client'
        align: "right"
      ,
        id: "nextMaintenanceDate"
        field: "nextMaintenanceDate"
        name: "#{TAPi18n.__('maintenances.nextMaintenanceDate')}"
        width:40
        sortable: true
        search: where: 'client'
        formatter: FleetrGrid.Formatters.dateFormatter
      ,
        id: "nextMaintenanceOdometer"
        field: "nextMaintenanceOdometer"
        name: "#{TAPi18n.__('maintenances.nextMaintenanceOdometer')}"
        width:40
        sortable: true
        align : "right"
        search: where: 'client'
        align: "right"
      ,
        id: "nextMaintenanceEngineHours"
        field: "nextMaintenanceEngineHours"
        name: "#{TAPi18n.__('maintenances.nextMaintenanceEngineHours')}"
        width:40
        align : "right"
        sortable: true
        hidden: true
        search: where: 'client'
        align: "right"
      ,
        id: "performed"
        field: "performed"
        name: "#{TAPi18n.__('maintenances.performed')}"
        maxWidth:30
        sortable: true
        search: where: 'client'
        groupable: true
        formatter: FleetrGrid.Formatters.blazeFormatter Template.performedMaintenance
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
