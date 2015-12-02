getDateRow = (field) -> (row) -> new Date(row[field]).toLocaleDateString 'en-US'

fleetrGridConfig =
  columns: [
    id: "fleetName"
    field: "fleetName"
    name: "#{TAPi18n.__('fleet.title')}"
    width:100
    sortable: true
    search:
      where: 'client'
    groupable: true 
  ,  
    id: "vehicleName"
    field: "vehicleName"
    name: "#{TAPi18n.__('vehicles.title')}"
    width:100
    sortable: true
    search:
      where: 'client'
    groupable: true
  ,
    id: "nextMaintenanceDate"
    field: "nextMaintenanceDate"
    name: "#{TAPi18n.__('reports.maintenance.nextMaintenanceDate')}"
    width:50
    sortable: true
    align: 'left'
    formatter: FleetrGrid.Formatters.dateFormatter
    search:
      where: 'server'
      dateRange: DateRanges.future
    groupable: true
  ,
    id: "daysToMaintenance"
    field: "daysToMaintenance"
    name: TAPi18n.__('reports.maintenance.daysToMaintenance')
    width:50
    sortable: true
    align: 'right'
    formatter: FleetrGrid.Formatters.roundFloat()
    search:
      where: 'server'
  ,
    id: 'nextMaintenanceOdometer'
    field: 'nextMaintenanceOdometer'
    name: "#{TAPi18n.__('reports.maintenance..nextMaintenanceOdometer')}"
    width:50
    align: 'right'
    sortable: true
    search:
      where: 'client'
  ,    
    id: 'odometerToMaintenance'
    field: 'odometerToMaintenance'
    name: "#{TAPi18n.__('reports.maintenance.odometerToMaintenance')}"
    width:50
    align: 'right'
    sortable: true
    search: where: 'server'
  ,
    id: 'nextMaintenanceEngineHours'
    field: 'nextMaintenanceEngineHours'
    name: "#{TAPi18n.__('reports.maintenance.nextMaintenanceEngineHours')}"
    width:50
    hidden: true
    align: 'right'
    sortable: true
    search:
      where: 'server'  
  ,
    id: 'engineHoursToMaintenance'
    field: 'engineHoursToMaintenance'
    name: "#{TAPi18n.__('reports.maintenance.engineHoursToMaintenance')}"
    width:50
    hidden: true
    align: 'right'
    sortable: true
    search: where: 'server'
  ]
  options:
    enableCellNavigation: true
    enableColumnReorder: false
    showHeaderRow: true
    explicitInitialization: true
    forceFitColumns: true
  remoteMethod: 'getMaintenanceVehicles'
  customize: (grid) ->
    now = moment()
    future = moment().add(1, 'months')
    grid.addFilter 'server', "#{TAPi18n.__('reports.maintenance.nextMaintenanceDate')}", "#{now.format('YYYY-MM-DD')} - #{future.format('YYYY-MM-DD')}",
      {maintenanceDateMin: now.toISOString(), maintenanceDateMax: future.toISOString()}, false

Template.maintenanceReport.helpers
  fleetrGridConfig: -> fleetrGridConfig
  pageTitle: -> "#{TAPi18n.__('reports.maintenance.title')}"

Template.maintenanceReport.events
  'rowsSelected #maintenanceGrid': (event) ->
    console.log 'rowsSelected #maintenanceGrid', event
