@MyGrid = {}
dataView = null

addId = (item) -> item.id = item._id; item;
dateFormatter = (row, cell, value) -> new Date(value).toLocaleDateString 'en-US'

getDateRow = (field) -> (row) -> new Date(row[field]).toLocaleDateString 'en-US'

sumTotalsFormatter = (totals, columnDef) ->
  val = totals.sum && totals.sum[columnDef.field];
  if val
    "&euro; " + ((Math.round(parseFloat(val)*100)/100));
  else "-"

columns = [
  { id: "type", name: "Type", field: "expenseTypeName", sortable: true }
  { id: "description", name: "Description", field: "description" }
  { id: "expenseGroup", name: "Group", field: "expenseGroupName", sortable: true }
  { id: "vehicle", name: "Vehicle", field: "vehicleName", sortable: true }
  { id: "driver", name: "Driver", field: "driverName", sortable: true }
  { id: "fleet", name: "Fleet", field: "fleetName", sortable: true }
  { id: "date", name: "Date", field: "timestamp", sortable: true, formatter: dateFormatter }
  { id: "invoiceNo", name: "Invoice NO.", field: "invoiceNr", sortable: true }
  { id: "quantity", name: "quantity", field: "quantity", sortable: true, groupTotalsFormatter: sumTotalsFormatter }
  { id: "amountGross", name: "Amount Gross", field: "total", sortable: true, groupTotalsFormatter: sumTotalsFormatter }
  { id: "amountVat", name: "VAT", field: "totalVATIncluded", sortable: true, groupTotalsFormatter: sumTotalsFormatter }
  { id: "amountDiscount", name: "Discount", field: "discount", sortable: true, groupTotalsFormatter: sumTotalsFormatter }
  { id: "note", name: "Note", field: "note" }
]
# { id: "amountNet", name: "Amount Net", field: "total" }                # sum

Template.expenseReport.events
  'click #groupByDate': (event, tpl) -> groupBy dataView, getDateRow('timestamp'), 'Date'
  'click #groupByType': (event, tpl) -> groupBy dataView, 'expenseTypeName', 'Type'
  'click #groupByGroup': (event, tpl) -> groupBy dataView, 'expenseGroupName', 'Group'
  'click #groupByVehicle': (event, tpl) -> groupBy dataView, 'vehicleName', 'Vehicle'
  'click #groupByFleet': (event, tpl) -> groupBy dataView, 'fleetName', 'Fleet'
  'click #groupByFleetGroup': (event, tpl) -> #tbd, see method
  'click #resetGroupBy': (event, tpl) -> dataView.setGrouping []

Template.expenseReport.onRendered ->

  Meteor.call 'getExpenses', (err, expenses) ->
    console.log 'getExpenses', err, expenses
    expenses = expenses.map(addId)

    options =
      enableCellNavigation: true
      enableColumnReorder: false

    groupItemMetadataProvider = new Slick.Data.GroupItemMetadataProvider()
    dataView = new Slick.Data.DataView
      groupItemMetadataProvider: groupItemMetadataProvider,
      inlineFilters: true
    MyGrid.grid = grid = new Slick.Grid '#slickgrid', dataView, columns, options

    grid.onSort.subscribe (e, args) ->
      # args: sort information.
      field = args.sortCol.field
      rows.sort (a, b) ->
        result = if a[field] > b[field] then 1 else if a[field] < b[field] then -1 else 0
        if args.sortAsc then result else -result
      slickgrid.invalidate()

    dataView.onRowCountChanged.subscribe (e, args) ->
      grid.updateRowCount()
      grid.render()
    dataView.onRowsChanged.subscribe (e, args) ->
      grid.invalidateRows(args.rows)
      grid.render()
    # register the group item metadata provider to add expand/collapse group handlers
    grid.registerPlugin(groupItemMetadataProvider);
    grid.setSelectionModel(new Slick.CellSelectionModel());
    columnpicker = new Slick.Controls.ColumnPicker(columns, grid, options);
    #var pager = new Slick.Controls.Pager(dataView, grid, $("#pager"));

    dataView.beginUpdate()
    dataView.setItems expenses
    #groupBy dataView, 'expenseGroupName'
    grid.autosizeColumns()
    dataView.endUpdate()

groupBy = (dataView, field, fieldName) ->
  dataView.setGrouping
    getter: field
    formatter: (g) ->
      "<strong>#{fieldName}:</strong> " + g.value + "  <span style='color:green'>(" + g.count + " items)</span>"
    aggregators: [
      new Slick.Data.Aggregators.Sum('total')
      new Slick.Data.Aggregators.Sum('quantity')
      new Slick.Data.Aggregators.Sum('totalVATIncluded')
      new Slick.Data.Aggregators.Sum('discount')
    ],
    aggregateCollapsed: false,
    lazyTotalsCalculation: true
