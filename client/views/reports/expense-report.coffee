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
  { id: "date", name: "Date", field: "timestamp", width:120, sortable: true, formatter: dateFormatter, allowDateSearch: true }
  { id: "type", name: "Type", field: "expenseTypeName", sortable: true, allowSearch: true }
  { id: "description", name: "Description", field: "description", width:100, allowSearch: true, hidden:true }
  { id: "expenseGroup", name: "Group", field: "expenseGroupName", sortable: true, allowSearch: true, hidden:true }
  { id: "vehicle", name: "Vehicle", field: "vehicleName", sortable: true, allowSearch: true }
  { id: "driver", name: "Driver", field: "driverName", sortable: true, allowSearch: true }
  { id: "fleet", name: "Fleet", field: "fleetName", sortable: true, allowSearch: true }
  { id: "invoiceNo", name: "Invoice NO.", field: "invoiceNr", sortable: true, width:75, hidden:true }
  { id: "quantity", name: "Quantity", field: "quantity", width:75, sortable: true, groupTotalsFormatter: sumTotalsFormatter('') }
  { id: "totalVat", name: "Total+VAT", field: "totalVATIncluded", width:75, sortable: true, formatter: euroFormatter, groupTotalsFormatter: sumEuroTotalsFormatter }
  { id: "amountVat", name: "VAT", field: "vat", width:50, sortable: true, formatter: euroFormatter, groupTotalsFormatter: sumEuroTotalsFormatter }
  { id: "amountDiscount", name: "Discount", field: "discount", width:75, sortable: true, formatter: euroFormatter, groupTotalsFormatter: sumEuroTotalsFormatter }
  { id: "total", name: "Total", field: "total", width:80, sortable: true, formatter: euroFormatter, groupTotalsFormatter: sumEuroTotalsFormatter }
]

options =
  enableCellNavigation: false
  enableColumnReorder: false
  showHeaderRow: true
  headerRowHeight: 30
  explicitInitialization: true
  forceFitColumns: true

MyGrid = new FleetrGrid options, columns

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
    # temp
    if @type is 'server'
      Meteor.call 'getExpenses', (err, expenses) ->
        MyGrid.setGridData( expenses.map addId )
  'click #groupByDate': (event, tpl) -> MyGrid.addGroupBy getDateRow('timestamp'), 'Date'
  'click #groupByType': (event, tpl) -> MyGrid.addGroupBy 'expenseTypeName', 'Type'
  'click #groupByGroup': (event, tpl) -> MyGrid.addGroupBy 'expenseGroupName', 'Group'
  'click #groupByVehicle': (event, tpl) -> MyGrid.addGroupBy 'vehicleName', 'Vehicle'
  'click #groupByFleet': (event, tpl) -> MyGrid.addGroupBy 'fleetName', 'Fleet'
  'click #resetGroupBy': (event, tpl) -> MyGrid.resetGroupBy()
  'apply.daterangepicker #date-range-filter': (event,p) ->
    startDate = $('#date-range-filter').data('daterangepicker').startDate
    endDate = $('#date-range-filter').data('daterangepicker').endDate
    start = startDate.format('YYYY-MM-DD')
    stop = endDate.format('YYYY-MM-DD')
    range = {$gte: start, $lte: stop}
    MyGrid.addFilter 'server', 'Date', "#{start} - #{stop}",
      {startDate: startDate.toISOString(), endDate: endDate.toISOString()}
    Meteor.call 'getExpenses', startDate.toISOString(), endDate.toISOString(), (err, expenses) ->
      MyGrid.setGridData( expenses.map addId )
