@MyGrid = {}
activeFilters = new Mongo.Collection null
dataView = null

addGroupBy = (fieldOrFunc, name) ->
  unless activeFilters.findOne(name: name)
    activeFilters.insert name: name
    groupBy dataView, fieldOrFunc, name

Template.expenseReport.helpers
  activeFilters: activeFilters.find()

Template.expenseReport.events
  'click .removeFilter': ->
    activeFilters.remove name: @name
    removeGroupBy @name
  'click #groupByDate': (event, tpl) -> addGroupBy getDateRow('timestamp'), 'Date'
  'click #groupByType': (event, tpl) -> addGroupBy 'expenseTypeName', 'Type'
  'click #groupByGroup': (event, tpl) -> addGroupBy 'expenseGroupName', 'Group'
  'click #groupByVehicle': (event, tpl) -> addGroupBy 'vehicleName', 'Vehicle'
  'click #groupByFleet': (event, tpl) -> addGroupBy 'fleetName', 'Fleet'
  'click #groupByFleetGroup': (event, tpl) -> #tbd, see method
  'click #resetGroupBy': (event, tpl) -> dataView.setGrouping []

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
  { id: "quantity", name: "Quantity", field: "quantity", sortable: true, groupTotalsFormatter: sumTotalsFormatter('') }
  { id: "amountGross", name: "Amount Gross", field: "total", sortable: true, formatter: euroFormatter, groupTotalsFormatter: sumEuroTotalsFormatter }
  { id: "amountVat", name: "VAT", field: "totalVATIncluded", sortable: true, formatter: euroFormatter, groupTotalsFormatter: sumEuroTotalsFormatter }
  { id: "amountDiscount", name: "Discount", field: "discount", sortable: true, formatter: euroFormatter, groupTotalsFormatter: sumEuroTotalsFormatter }
  { id: "note", name: "Note", field: "note" }
]
# { id: "amountNet", name: "Amount Net", field: "total" }                # sum

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
      grid.render()
    dataView.onRowsChanged.subscribe (e, args) ->
      # totals rows, the two last ones, should always be visually updated
      args.rows.push dataView.getLength()
      args.rows.push dataView.getLength() + 1
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
    grid.autosizeColumns()
    dataView.endUpdate()

    # update and render totals row
    MyDP.updateTotals()
    grid.invalidateRows [dataView.getLength() + 1]
    grid.render()

groupings = {}
groupBy = (dataView, field, fieldName) ->
  aggregators = [
    new Slick.Data.Aggregators.Sum('total')
    new Slick.Data.Aggregators.Sum('totalVATIncluded')
    new Slick.Data.Aggregators.Sum('discount')
  ]
  aggregators.push new Slick.Data.Aggregators.Sum('quantity') if field == 'expenseTypeName'
  console.log 'collapsed?', Object.keys(groupings).length > 0
  groupings[fieldName] =
    getter: field
    formatter: (g) ->
      "<strong>#{fieldName}:</strong> " + g.value + "  <span style='color:green'>(" + g.count + " items)</span>"
    aggregators: aggregators
    collapsed: Object.keys(groupings).length > 0
    aggregateCollapsed: true
    lazyTotalsCalculation: true
  effectuateGroupings()

removeGroupBy = (name) ->
  delete groupings[name]
  effectuateGroupings()

effectuateGroupings = ->
  dataView.setGrouping (val for key, val of groupings)


TotalsDataProvider = (dataView, columns, fields) ->
  totals = {}
  totalsMetadata =
    cssClasses: "totals"
    columns: {}
  emptyRowMetaData = columns: {}
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
    for column in columns
      if column.field in fields # only calculate total for the requested fields
        totals[column.field] = (parseInt dataView.getItem(idx)?[column.field] || 0 for idx in [0..dataView.getLength()-1]).reduce (p, c) -> p + c
  getItemMetadata: (index) ->
    if index < dataView.getLength()
      dataView.getItemMetadata index
     else if index == dataView.getLength()
      emptyRowMetaData
    else
      totalsMetadata
