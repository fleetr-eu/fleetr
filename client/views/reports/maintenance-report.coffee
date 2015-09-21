columns = [
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

options =
  enableCellNavigation: true
  enableColumnReorder: false
  showHeaderRow: true
  headerRowHeight: 30
  explicitInitialization: true
  forceFitColumns: true

MyGrid = new FleetrGrid options, columns, 'getMaintenanceVehicles'
now = moment()
future = moment().add(29, 'days')
MyGrid.addFilter 'server', 'Maintenance Date', "#{now.format('YYYY-MM-DD')} - #{future.format('YYYY-MM-DD')}",
  {maintenanceDateMin: now.toISOString(), maintenanceDateMax: future.toISOString()}, false

Template.maintenanceReport.onRendered ->
  MyGrid.install()

Template.maintenanceReport.helpers
  activeGroupings:  MyGrid.activeGroupingsCursor
  activeFilters:    MyGrid.activeFiltersCursor

Template.maintenanceReport.events
  'click .removeGroupBy': ->
    MyGrid.removeGroupBy @name
  'click .removeFilter': ->
    MyGrid.removeFilter @type, @name
  'apply.daterangepicker #date-range-filter': (event,p) ->
    startDate = $('#date-range-filter').data('daterangepicker').startDate
    endDate = $('#date-range-filter').data('daterangepicker').endDate
    start = startDate.format('YYYY-MM-DD')
    stop = endDate.format('YYYY-MM-DD')
    range = {$gte: start, $lte: stop}
    MyGrid.addFilter 'server', 'Maintenance Date', "#{start} - #{stop}",
      {maintenanceDateMin: startDate.toISOString(), maintenanceDateMax: endDate.toISOString()}
  'rowsSelected #slickgrid': (event) ->
    console.log 'rowsSelected #slickgrid', event
