@SlickGrid = ->

  @grid = null
  @data = []

  @install = ->
    # Handle changes to client rendered fitlers
    @_activeFilters.find(type: 'client').observe
      added: @addColumnFilter
      changed: @addColumnFilter
      removed: @removeColumnFilter

    # Handle changes to server rendered fitlers
    @_activeFilters.find(type: 'server').observe
      removed: -> $('#date-range-filter').val('')
    @

  # column filters -->
  @_activeFilters = new Mongo.Collection null
  @activeFiltersCursor = @_activeFilters.find()
  @columnFilters = {}
  @addColumnFilter = (filter) =>
    regex = new RegExp filter.spec.regex, 'i'
    @columnFilters[filter.spec.field] = (text) -> "#{text}".match regex
    applyFilters()
  @removeColumnFilter = (filter) =>
    delete @columnFilters[filter.spec.field]
    $("#searchbox-#{filter.spec.field}").val('')
    applyFilters()
  @addFilter = (type, name, text, spec) ->
    @_activeFilters.upsert {name: name, type: type}, {name: name, type: type, text: text, spec:spec}
  @removeFilter = (type, name) ->
    @_activeFilters.remove name: name, type: type
  # <-- column filters

  @_activeGroupings = new Mongo.Collection null
  @activeGroupingsCursor = @_activeGroupings.find()
  @_groupings = {}
  @resetGroupBy = ->
    @_groupings = {}
    @_activeGroupings.remove {}
    @_effectuateGroupings()

  @addGroupBy = (field, fieldName) ->
    if @_activeGroupings.findOne(name: fieldName) then return
    aggregators = [
      new Slick.Data.Aggregators.Sum('total')
      new Slick.Data.Aggregators.Sum('totalVATIncluded')
      new Slick.Data.Aggregators.Sum('discount')
    ]
    aggregators.push new Slick.Data.Aggregators.Sum('quantity') if field == 'expenseTypeName'
    @_groupings[fieldName] =
      getter: field
      formatter: (g) ->
        "<strong>#{fieldName}:</strong> " + g.value + "  <span style='color:green'>(" + g.count + " items)</span>"
      aggregators: aggregators
      collapsed: Object.keys(@_groupings).length > 0
      aggregateCollapsed: true
      lazyTotalsCalculation: true
    @_activeGroupings.insert name: fieldName
    @_effectuateGroupings()

  @removeGroupBy = (name) ->
    @_activeGroupings.remove name: name
    delete @_groupings[name]
    @_effectuateGroupings()

  @_effectuateGroupings = ->
    dataView.setGrouping (val for key, val of @_groupings)

  @install()

MyGrid = new SlickGrid()

dataView = null


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
        setGridData( expenses.map addId )
  'click #groupByDate': (event, tpl) -> MyGrid.addGroupBy getDateRow('timestamp'), 'Date'
  'click #groupByType': (event, tpl) -> MyGrid.addGroupBy 'expenseTypeName', 'Type'
  'click #groupByGroup': (event, tpl) -> MyGrid.addGroupBy 'expenseGroupName', 'Group'
  'click #groupByVehicle': (event, tpl) -> MyGrid.addGroupBy 'vehicleName', 'Vehicle'
  'click #groupByFleet': (event, tpl) -> MyGrid.addGroupBy 'fleetName', 'Fleet'
  'click #groupByFleetGroup': (event, tpl) -> #tbd, see method
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
# { id: "amountNet", name: "Amount Net", field: "total" }                # sum

Template.expenseReport.onRendered ->

  #DateRangeFilter.install $ '#date-range-filter'

  options =
    enableCellNavigation: false
    enableColumnReorder: false
    showHeaderRow: true
    headerRowHeight: 30
    explicitInitialization: true
    forceFitColumns: true

  groupItemMetadataProvider = new Slick.Data.GroupItemMetadataProvider()
  dataView = new Slick.Data.DataView
    groupItemMetadataProvider: groupItemMetadataProvider,
    inlineFilters: true

  MyGrid.dp = TotalsDataProvider dataView, columns, ['total', 'totalVATIncluded', 'vat', 'discount']
  MyGrid.grid = grid = new Slick.Grid '#slickgrid', MyGrid.dp, columns, options


  comparer = (sortcol) -> (a, b) ->
    x = a[sortcol]
    y = b[sortcol]
    if x == y then 0 else if x > y then 1 else -1

  grid.onSort.subscribe (e, args) ->
    sortdir = args.sortAsc ? 1 : -1;
    sortcol = args.sortCol.field
    dataView.sort(comparer(sortcol), args.sortAsc)

  $(grid.getHeaderRow()).delegate ":input", "change keyup", (e) ->
    columnId = $(this).data("columnId");
    if columnId
      column = (columns.filter (column) -> column.id == columnId)[0]
      if $(this).val().length
        MyGrid.addFilter 'client', column.name, $(this).val(),
          { field: column.field, regex: "#{$(this).val()}" }
      else
        MyGrid.removeFilter 'client', column.name
  grid.onHeaderRowCellRendered.subscribe (e, args) ->
    $(args.node).empty()
    if args.column.allowSearch
      $('<span class="glyphicon glyphicon-search searchbox" aria-hidden="true"></span>').appendTo(args.node)
      $("<input id='searchbox-#{args.column.field}' type='text' class='searchbox'>")
         .data("columnId", args.column.id)
         .appendTo(args.node)
    else if args.column.allowDateSearch
      $('<input id="date-range-filter" class="searchbox" type="text" placeholder="Filter on date">').appendTo args.node
      DateRangeFilter.install $ '#date-range-filter'
    else
      $("<div class='searchdisabled'>&nbsp;</div>").appendTo args.node

  dataView.onRowCountChanged.subscribe (e, args) ->
    MyGrid.dp.updateTotals()
    dl = if dataView.getLength() then dataView.getLength() else 0
    grid.invalidateRows [dl, dl+1]
    grid.updateRowCount()
    grid.render()
  dataView.onRowsChanged.subscribe (e, args) ->
    # totals rows, the two last ones, should always be visually updated
    dl = if dataView.getLength() then dataView.getLength() else 0
    args.rows.push dl
    args.rows.push dl + 1
    grid.invalidateRows(args.rows)
    grid.updateRowCount()
    grid.render()
  # register the group item metadata provider to add expand/collapse group handlers
  grid.registerPlugin(groupItemMetadataProvider);
  #grid.registerPlugin(headerMenuPlugin);
  grid.init()
  #grid.setSelectionModel(new Slick.CellSelectionModel());
  columnpicker = new Slick.Controls.ColumnPicker(columns, grid, options);
  #var pager = new Slick.Controls.Pager(dataView, grid, $("#pager"));

  Meteor.call 'getExpenses', (err, expenses) -> setGridData( expenses.map addId )

filter = `function filter(item) {
  for (var field in MyGrid.columnFilters) {
    if (item[field] && !MyGrid.columnFilters[field](item[field])) {
      return false;
    }
  }
  return true;
}`

applyFilters = () ->
  setGridData MyGrid.data.filter( (item) -> filter item), false
setGridData = (data, save = true) ->
  MyGrid.data = data if save
  dataView.beginUpdate()
  dataView.setItems data
  MyGrid.grid.autosizeColumns()
  dataView.endUpdate()

  # update and render totals row
  MyGrid.dp.updateTotals()
  dl = if dataView.getLength() then dataView.getLength() else 0
  MyGrid.grid.invalidateRows [dl, dl + 1]
  MyGrid.grid.render()


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
    dl = if dataView.getLength() then dataView.getLength() else 0
    dl + 2
  getItem: (index) ->
    dl = if dataView.getLength() then dataView.getLength() else 0
    if index < dl
      dataView.getItem index
     else if index == dl
      emptyRow
    else
      totals
  updateTotals: ->
    for column in columns
      if column.field in fields # only calculate total for the requested fields
        groups = dataView.getGroups()
        if groups && groups.length
          totals[column.field] = dataView.getGroups().reduce (total, group) ->
            total + (parseInt group.totals?.sum?[column.field] || 0)
          , 0
        else
          dl = if dataView.getLength() then dataView.getLength() else 0
          totals[column.field] = (parseInt dataView.getItem(idx)?[column.field] || 0 for idx in [0..dl-1])
          .reduce(((p, c) -> p + c), 0)
  getItemMetadata: (index) ->
    dl = if dataView.getLength() then dataView.getLength() else 0
    if index < dl
      dataView.getItemMetadata index
     else if index == dl
      emptyRowMetaData
    else
      totalsMetadata
