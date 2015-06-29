addId = (item) -> item.id = item._id; item;
dateFormatter = (row, cell, value) -> if value then new Date(value).toLocaleDateString 'en-US' else ''
euroFormatter = (row, cell, value) -> "&euro; #{if value then value else '0'}"

getDateRow = (field) -> (row) -> new Date(row[field]).toLocaleDateString 'en-US'

sumTotalsFormatter = (sign = '') -> (totals, columnDef) ->
  val = totals.sum && totals.sum[columnDef.field];
  if val
    "#{sign} " + ((Math.round(parseFloat(val)*100)/100));
  else ''
sumEuroTotalsFormatter = sumTotalsFormatter '&euro;'


columns = [
  id: "date"
  field: "timestamp"
  name: "Date"
  width:120
  sortable: true
  formatter: dateFormatter
  search:
    where: 'server'
    dateRange: DateRanges.history
,
  id: "type"
  field: "expenseTypeName"
  name: "Type"
  sortable: true
  search:
    where: 'client'
,
  id: "description"
  field: "description"
  name: "Description"
  width:100
  hidden:true
  search:
    where: 'client'
,
  id: "expenseGroup"
  field: "expenseGroupName"
  name: "Group"
  sortable: true
  hidden:true,
  search:
    where: 'client'
,
  id: "vehicle"
  field: "vehicleName"
  name: "Vehicle"
  sortable: true
  search:
    where: 'client'
,
  id: "driver"
  field: "driverName"
  name: "Driver"
  sortable: true
  search:
    where: 'client'
,
  id: "fleet"
  field: "fleetName"
  name: "Fleet"
  sortable: true
  search:
    where: 'client'
,
  id: "invoiceNo"
  field: "invoiceNr"
  name: "Invoice NO."
  sortable: true
  width:75
  hidden:true
,
  id: "quantity"
  field: "quantity"
  name: "Quantity"
  width:75
  sortable: true
  groupTotalsFormatter: sumTotalsFormatter()
,
  id: "totalVat"
  field: "totalVATIncluded"
  name: "Total+VAT"
  width:75
  sortable: true
  grandTotal: true
  formatter: euroFormatter
  groupTotalsFormatter: sumEuroTotalsFormatter
,
  id: "amountVat"
  field: "vat"
  name: "VAT"
  width:50
  sortable: true
  grandTotal: true
  formatter: euroFormatter
  groupTotalsFormatter: sumEuroTotalsFormatter
,
  id: "amountDiscount"
  field: "discount"
  name: "Discount"
  width:75
  sortable: true
  grandTotal: true
  formatter: euroFormatter
  groupTotalsFormatter: sumEuroTotalsFormatter
,
  id: "total"
  field: "total"
  name: "Total"
  width:80
  sortable: true
  grandTotal: true
  formatter: euroFormatter
  groupTotalsFormatter: sumEuroTotalsFormatter
]

aggregatorsBasic = [
  new Slick.Data.Aggregators.Sum('total')
  new Slick.Data.Aggregators.Sum('totalVATIncluded')
  new Slick.Data.Aggregators.Sum('discount')
]
aggregatorsQuantity = aggregatorsBasic.concat [
  new Slick.Data.Aggregators.Sum('quantity')
]

options =
  enableCellNavigation: false
  enableColumnReorder: false
  showHeaderRow: true
  headerRowHeight: 30
  explicitInitialization: true
  forceFitColumns: true

MyGrid = new FleetrGrid options, columns, 'getExpenses'

Template.expenseReport.onRendered ->
  MyGrid.install()

Template.expenseReport.helpers
  activeGroupings:  MyGrid.activeGroupingsCursor
  activeFilters:    MyGrid.activeFiltersCursor

Template.expenseReport.events
  'click .removeGroupBy': ->
    MyGrid.removeGroupBy @name
  'click .removeFilter': ->
    MyGrid.removeFilter @type, @name
  'click #groupByDate': (event, tpl) -> MyGrid.addGroupBy getDateRow('timestamp'), 'Date', aggregatorsBasic
  'click #groupByType': (event, tpl) -> MyGrid.addGroupBy 'expenseTypeName', 'Type', aggregatorsQuantity
  'click #groupByGroup': (event, tpl) -> MyGrid.addGroupBy 'expenseGroupName', 'Group', aggregatorsBasic
  'click #groupByVehicle': (event, tpl) -> MyGrid.addGroupBy 'vehicleName', 'Vehicle', aggregatorsBasic
  'click #groupByFleet': (event, tpl) -> MyGrid.addGroupBy 'fleetName', 'Fleet', aggregatorsBasic
  'click #resetGroupBy': (event, tpl) -> MyGrid.resetGroupBy()
  'apply.daterangepicker #date-range-filter': (event,p) ->
    startDate = $('#date-range-filter').data('daterangepicker').startDate
    endDate = $('#date-range-filter').data('daterangepicker').endDate
    start = startDate.format('YYYY-MM-DD')
    stop = endDate.format('YYYY-MM-DD')
    range = {$gte: start, $lte: stop}
    MyGrid.addFilter 'server', 'Date', "#{start} - #{stop}",
      {startDate: startDate.toISOString(), endDate: endDate.toISOString()}
