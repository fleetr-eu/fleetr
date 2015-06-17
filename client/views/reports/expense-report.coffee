@MyGrid =
  grid: null
  columnFilters: {}
  addColumnFilter: (filter) ->
    console.log 'addColumnFilter', filter
    regex = new RegExp filter.spec.regex
    @columnFilters[filter.spec.field] = (text) -> "#{text}".match regex
    dataView.refresh()
  removeColumnFilter: (filter) ->
    delete @columnFilters[filter.spec.field]
    dataView.refresh()

activeGroupings = new Mongo.Collection null
activeFilters   = new Mongo.Collection null
dataView = null

activeFilters.find(type:'client').observe
  added: MyGrid.addColumnFilter.bind MyGrid
  changed: MyGrid.addColumnFilter.bind MyGrid
  removed: MyGrid.removeColumnFilter.bind MyGrid

addGroupBy = (fieldOrFunc, name) ->
  unless activeGroupings.findOne(name: name)
    activeGroupings.insert name: name
    groupBy dataView, fieldOrFunc, name

@addFilter = (type, name, text, spec) ->
  activeFilters.upsert {name: name, type: type}, {name: name, type: type, text: text, spec:spec}
@removeFilter = (type, name) ->
  activeFilters.remove name: name, type: type

Template.expenseReport.helpers
  activeGroupings:  activeGroupings.find()
  activeFilters:    activeFilters.find()

Template.expenseReport.events
  'click .removeGroupBy': ->
    activeGroupings.remove name: @name
    removeGroupBy @name
  'click .removeFilter': ->
    removeFilter @type, @name
    # temp
    Meteor.call 'getExpenses', (err, expenses) ->
      setGridData( expenses.map addId )
  'click #groupByDate': (event, tpl) -> addGroupBy getDateRow('timestamp'), 'Date'
  'click #groupByType': (event, tpl) -> addGroupBy 'expenseTypeName', 'Type'
  'click #groupByGroup': (event, tpl) -> addGroupBy 'expenseGroupName', 'Group'
  'click #groupByVehicle': (event, tpl) -> addGroupBy 'vehicleName', 'Vehicle'
  'click #groupByFleet': (event, tpl) -> addGroupBy 'fleetName', 'Fleet'
  'click #groupByFleetGroup': (event, tpl) -> #tbd, see method
  'click #resetGroupBy': (event, tpl) -> dataView.setGrouping []
  'apply.daterangepicker #date-range-filter': (event,p) ->
    startDate = $('#date-range-filter').data('daterangepicker').startDate
    endDate = $('#date-range-filter').data('daterangepicker').endDate
    start = startDate.format('YYYY-MM-DD')
    stop = endDate.format('YYYY-MM-DD')
    console.log start + ' - ' + stop
    range = {$gte: start, $lte: stop}
    console.log range
    console.log startDate.unix(), endDate.unix()
    addFilter 'server', 'Date', "#{start} - #{stop}",
      {startDate: startDate.toISOString(), endDate: endDate.toISOString()}
    Meteor.call 'getExpenses', startDate.toISOString(), endDate.toISOString(), (err, expenses) ->
      setGridData( expenses.map addId )

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

  DateRangeFilter.install $ '#date-range-filter'

  options =
    enableCellNavigation: false
    enableColumnReorder: false
    showHeaderRow: true
    headerRowHeight: 30
    explicitInitialization: true

  groupItemMetadataProvider = new Slick.Data.GroupItemMetadataProvider()
  dataView = new Slick.Data.DataView
    groupItemMetadataProvider: groupItemMetadataProvider,
    inlineFilters: true

  MyGrid.dp = TotalsDataProvider dataView, columns, ['total', 'totalVATIncluded', 'discount']
  MyGrid.grid = grid = new Slick.Grid '#slickgrid', MyGrid.dp, columns, options

  grid.onSort.subscribe (e, args) ->
    # args: sort information.
    field = args.sortCol.field
    rows.sort (a, b) ->
      result = if a[field] > b[field] then 1 else if a[field] < b[field] then -1 else 0
      if args.sortAsc then result else -result
    grid.invalidate()


  $(grid.getHeaderRow()).delegate ":input", "change keyup", (e) ->
    columnId = $(this).data("columnId");
    if columnId
      column = (columns.filter (column) -> column.id == columnId)[0]
      if $(this).val().length
        addFilter 'client', column.name, $(this).val(),
          { field: column.field, regex: "#{$(this).val()}" }
      else
        removeFilter 'client', column.name
  grid.onHeaderRowCellRendered.subscribe (e, args) ->
    $(args.node).empty()
    $("<input type='text'>")
       .data("columnId", args.column.id)
       #.val(columnFilters[args.column.id])
       .appendTo(args.node)

  filter = `function filter(item) {
    for (var field in MyGrid.columnFilters) {
      if (item[field] && !MyGrid.columnFilters[field](item[field])) {
        console.log('not included::', field, item[field])
        return false;
      }
    }
    return true;
  }`

  dataView.setFilter filter
  dataView.onRowCountChanged.subscribe (e, args) ->
    grid.invalidateRows [dataView.getLength(), dataView.getLength()+1]
    grid.updateRowCount()
    grid.render()
  dataView.onRowsChanged.subscribe (e, args) ->
    # totals rows, the two last ones, should always be visually updated
    console.log 'onRowsChanged', args.rows
    args.rows.push dataView.getLength()
    args.rows.push dataView.getLength() + 1
    grid.invalidateRows(args.rows)
    grid.updateRowCount()
    grid.render()
  # register the group item metadata provider to add expand/collapse group handlers
  grid.registerPlugin(groupItemMetadataProvider);
  grid.init()
  #grid.setSelectionModel(new Slick.CellSelectionModel());
  columnpicker = new Slick.Controls.ColumnPicker(columns, grid, options);
  #var pager = new Slick.Controls.Pager(dataView, grid, $("#pager"));

  Meteor.call 'getExpenses', (err, expenses) -> setGridData( expenses.map addId )

setGridData = (data) ->
  dataView.beginUpdate()
  dataView.setItems data
  MyGrid.grid.autosizeColumns()
  dataView.endUpdate()

  # update and render totals row
  MyGrid.dp.updateTotals()
  MyGrid.grid.invalidateRows [dataView.getLength(), dataView.getLength() + 1]
  MyGrid.grid.render()

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
        totals[column.field] = (parseInt dataView.getItem(idx)?[column.field] || 0 for idx in [0..dataView.getLength()-1])
        .reduce(((p, c) -> p + c), 0)
  getItemMetadata: (index) ->
    if index < dataView.getLength()
      dataView.getItemMetadata index
     else if index == dataView.getLength()
      emptyRowMetaData
    else
      totalsMetadata
