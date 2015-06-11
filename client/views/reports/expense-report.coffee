@MyGrid = {}
dataView = null

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
  { id: "type", name: "Type", field: "expenseTypeName", sortable: true }
  { id: "description", name: "Description", field: "description" }
  { id: "expenseGroup", name: "Group", field: "expenseGroupName", sortable: true }
  { id: "vehicle", name: "Vehicle", field: "vehicleName", sortable: true }
  { id: "driver", name: "Driver", field: "driverName", sortable: true }
  { id: "fleet", name: "Fleet", field: "fleetName", sortable: true }
  { id: "date", name: "Date", field: "timestamp", sortable: true, formatter: dateFormatter }
  { id: "invoiceNo", name: "Invoice NO.", field: "invoiceNr", sortable: true }
  { id: "quantity", name: "Quantity", field: "quantity", sortable: true, groupTotalsFormatter: sumTotalsFormatter('total:') }
  { id: "amountGross", name: "Amount Gross", field: "total", sortable: true, formatter: euroFormatter, groupTotalsFormatter: sumEuroTotalsFormatter }
  { id: "amountVat", name: "VAT", field: "totalVATIncluded", sortable: true, formatter: euroFormatter, groupTotalsFormatter: sumEuroTotalsFormatter }
  { id: "amountDiscount", name: "Discount", field: "discount", sortable: true, formatter: euroFormatter, groupTotalsFormatter: sumEuroTotalsFormatter }
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

    @MyDP = TotalsDataProvider dataView, columns, ['total', 'totalVATIncluded', 'discount']
    MyGrid.grid = grid = new Slick.Grid '#slickgrid', MyDP, columns, options

    grid.onSort.subscribe (e, args) ->
      # args: sort information.
      field = args.sortCol.field
      rows.sort (a, b) ->
        result = if a[field] > b[field] then 1 else if a[field] < b[field] then -1 else 0
        if args.sortAsc then result else -result
      slickgrid.invalidate()

    dataView.onRowCountChanged.subscribe (e, args) ->
      MyDP.updateTotals()
      grid.render()
    dataView.onRowsChanged.subscribe (e, args) ->
      args.rows.push dataView.getLength()
      args.rows.push dataView.getLength() + 1
      console.log 'onRowsChanged', args
      grid.invalidateRows(args.rows)
      grid.updateRowCount()
      grid.render()
    # register the group item metadata provider to add expand/collapse group handlers
    grid.registerPlugin(groupItemMetadataProvider);
    #grid.setSelectionModel(new Slick.CellSelectionModel());
    columnpicker = new Slick.Controls.ColumnPicker(columns, grid, options);
    #var pager = new Slick.Controls.Pager(dataView, grid, $("#pager"));

    dataView.beginUpdate()
    dataView.setItems expenses
    #groupBy dataView, 'expenseGroupName'
    grid.autosizeColumns()
    dataView.endUpdate()

groupBy = (dataView, field, fieldName) ->
  aggregators = [
    new Slick.Data.Aggregators.Sum('total')
    new Slick.Data.Aggregators.Sum('totalVATIncluded')
    new Slick.Data.Aggregators.Sum('discount')
  ]
  aggregators.push new Slick.Data.Aggregators.Sum('quantity') if field == 'expenseTypeName'
  dataView.setGrouping
    getter: field
    formatter: (g) ->
      "<strong>#{fieldName}:</strong> " + g.value + "  <span style='color:green'>(" + g.count + " items)</span>"
    aggregators: aggregators
    aggregateCollapsed: false
    lazyTotalsCalculation: true

TotalsDataProvider = (dataView, columns, fields) ->
  console.log dataView
  totals = {};
  totalsMetadata =
    #Style the totals row differently.
    cssClasses: "totals"
    columns: {}
  emptyRowMetaData = columns: {}
  #Make the totals not editable.
  #for i = 0; i < columns.length; i++
  totalsMetadata.columns[i] = { editor: null } for i in [0..columns.length]
  emptyRowMetaData.columns[i] = { editor: null, formatter: -> '' } for i in [0..columns.length]

  emptyRow = {}
  emptyRow[columns[i]?.field] = '' for i in [0..columns.length]

  expandGroup: (key) -> dataView.expandGroup key
  collapseGroup: (key) -> dataView.collapseGroup key
  getLength: ->
    dataView.getLength() + 2
  getItem: (index) ->
    if index < dataView.getLength()
      console.log 'getItem', index, dataView.getLength(), 'return', dataView.getItem index
      dataView.getItem index
     else if index == dataView.getLength()
      console.log 'getItem', index, dataView.getLength(), 'return', emptyRow
      emptyRow
    else
      console.log 'getItem', index, dataView.getLength(), 'return', totals
      totals
  updateTotals: ->
    columnIdx = columns.length
    while (columnIdx--)
      column = columns[columnIdx]
      if column.field in fields
        total = 0;
        i = dataView.getLength();
        total = total + (parseInt(dataView.getItem(i)[column.field], 10) || 0) while (i--)
        totals[column.field] = total
  getItemMetadata: (index) ->
    if index < dataView.getLength()
      dataView.getItemMetadata index
     else if index == dataView.getLength()
      emptyRowMetaData
    else
      totalsMetadata
