fleetrGridConfig =
  columns: [
    id: "maintenanceDate"
    field: "maintenanceDate"
    name: "Maintenance Date"
    width:120
    sortable: true
    align: 'left'
    formatter: FleetrGrid.Formatters.dateFormatter
    search:
      where: 'server'
      dateRange: DateRanges.future
    groupable: true
  ,
    id: 'odometerToMaintenance'
    field: 'odometerToMaintenance'
    name: 'KM\'s till maintenance'
    sortable: true
    search: where: 'server'
    align: 'right'
  ,
    id: 'engineHoursToMaintenance'
    field: 'engineHoursToMaintenance'
    name: 'Engine hours till maintenance'
    sortable: true
    search: where: 'server'
    align: 'center'
  ,
    id: 'nextMaintenanceOdometer'
    field: 'nextMaintenanceOdometer'
    name: 'Next Maintenance Odometer'
    sortable: true
    search:
      where: 'server'
  ,
    id: 'nextMaintenanceEngineHours'
    field: 'nextMaintenanceEngineHours'
    name: 'Next Maintenance Engine Hours'
    sortable: true
    search:
      where: 'server'
  ,
    id: "vehicleName"
    field: "vehicleName"
    name: "Name"
    sortable: true
  ,
    id: "fleetName"
    field: "fleetName"
    name: "Fleet"
    sortable: true
    search:
      where: 'client'
  ,
    id: "buttons"
    name: "Buttons"
    buttons: [
      value: "Edit"
      renderer: (value, row, cell, column, rowObject) ->
        "<button>Custom:#{value}</button>"
    ,
      value: "Delete"
    ]
    formatter: FleetrGrid.Formatters.buttonFormatter
  ]
  options:
    enableCellNavigation: true
    enableColumnReorder: false
    showHeaderRow: true
    headerRowHeight: 30
    explicitInitialization: true
    forceFitColumns: true
  remoteMethod: 'getMaintenanceVehicles'
  customize: (grid) ->
    now = moment()
    future = moment().add(29, 'days')
    grid.addFilter 'server', 'Maintenance Date', "#{now.format('YYYY-MM-DD')} - #{future.format('YYYY-MM-DD')}",
      {maintenanceDateMin: now.toISOString(), maintenanceDateMax: future.toISOString()}, false

#MyGrid = new FleetrGrid options, columns, 'getMaintenanceVehicles'


Template.maintenanceReport.helpers
  fleetrGridConfig: -> fleetrGridConfig
  pageTitle: -> "#{TAPi18n.__('reports.title')} &raquo; #{TAPi18n.__('reports.maintenance.title')}"

Template.maintenanceReport.events
  'rowsSelected #maintenanceGrid': (event) ->
    console.log 'rowsSelected #maintenanceGrid', event
