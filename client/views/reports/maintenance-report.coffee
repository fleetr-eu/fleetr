addId = (item) -> item.id = item._id; item;
dateFormatter = (row, cell, value) -> if value then new Date(value).toLocaleDateString 'en-US' else ''
euroFormatter = (row, cell, value) -> "&euro; #{if value then value else '0'}"

getDateRow = (field) -> (row) -> new Date(row[field]).toLocaleDateString 'en-US'

sumTotalsFormatter = (sign) -> (totals, columnDef) ->
  val = totals.sum && totals.sum[columnDef.field];
  if val
    "#{sign} " + ((Math.round(parseFloat(val)*100)/100));
  else ''
sumEuroTotalsFormatter = sumTotalsFormatter '&euro;'


columns = [
  id: "nextMaintenanceDate"
  field: "nextMaintenanceDate"
  name: "Next Maintenance Date"
  width:120
  sortable: true
  formatter: dateFormatter
  search:
    where: 'server'
    dateRange: DateRanges.future
  groupable: true
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
]

options =
  enableCellNavigation: false
  enableColumnReorder: false
  showHeaderRow: true
  headerRowHeight: 30
  explicitInitialization: true
  forceFitColumns: true

MyGrid = new FleetrGrid options, columns, 'getMaintenanceVehicles', false
now = moment()
future = moment().add(29, 'days')
MyGrid.addFilter 'server', 'Maintenance Date', "#{now.format('YYYY-MM-DD')} - #{future.format('YYYY-MM-DD')}",
  {maintenanceDateMin: now.toISOString(), maintenanceDateMax: future.toISOString()}

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
