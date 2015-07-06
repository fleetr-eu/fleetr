Helpers =
  addId: (item) -> item.id = item._id; item;

# Slickgrid data provider that implements a grand total row
TotalsDataProvider = (dataView, columns, grandTotalsColumns) ->
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
    if grandTotalsColumns.length then dl + 2 else dl
  getItem: (index) ->
    dl = if dataView.getLength() then dataView.getLength() else 0
    if index < dl
      dataView.getItem index
     else if index == dl
      emptyRow
    else
      totals
  updateTotals: ->
    for column in grandTotalsColumns
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

# Component that wraps SlickGrid and uses Meteorish constructs
@FleetrGrid = (options, columns, serverMethod, initializeData = true) ->

  @grid = null
  @_dataView = null
  @data = []

  # populates the data for the grid
  @setGridData = (data, store = true) =>
    @data = data if store
    @_dataView.beginUpdate()
    @_dataView.setItems data
    @grid.autosizeColumns()
    @_dataView.endUpdate()

    # update and render totals row
    @totalsDataProvider.updateTotals()
    length = @dataViewLength()
    @grid.invalidateRows [length, length + 1]
    @grid.render()

  @dataViewLength = -> if @_dataView.getLength() then @_dataView.getLength() else 0

  # column filters -->
  @_activeFilters = new Mongo.Collection null
  @activeFiltersCursor = @_activeFilters.find()
  @columnFilters = {}
  @addColumnFilter = (filter) =>
    for field of filter.spec
      regex = new RegExp filter.spec[field].regex, 'i'
      @columnFilters[field] = (text) -> "#{text}".match regex
    @_applyFilters()
  @removeColumnFilter = (filter) =>
    for field of filter.spec
      delete @columnFilters[field]
      $("#searchbox-#{field}").val('')
    @_applyFilters()
  @addFilter = (type, name, text, spec) ->
    @_activeFilters.upsert {name: name, type: type}, {name: name, type: type, text: text, spec:spec}
    @_refreshData() if type == 'server'
    #@_applyFilters() if type == 'client'
  @removeFilter = (type, name) ->
    @_activeFilters.remove name: name, type: type
    @_refreshData() if type == 'server'
    #@_applyFilters() if type == 'client'
    $('#date-range-filter').val('')
  @_applyFilters = =>
    @setGridData (@data.filter @_filter), false
  @_refreshData = =>
    serverFilterSpec = {}
    items = @_activeFilters.find({type: 'server'}).fetch()
    _.extend serverFilterSpec, item.spec for item in items
    Meteor.call serverMethod, serverFilterSpec, (err, items) =>
      @setGridData( items.map Helpers.addId )
      @_applyFilters()
  @_filter = (item) =>
    console.log @columnFilters
    for field of @columnFilters
      if item[field] and !@columnFilters[field](item[field])
        console.log item[field], 'does not match'
        return false
    true
  # <-- column filters

  # grouping -->
  @_activeGroupings = new Mongo.Collection null
  @activeGroupingsCursor = @_activeGroupings.find()
  @_groupings = {}
  @resetGroupBy = ->
    @_groupings = {}
    @_activeGroupings.remove {}
    @_effectuateGroupings()
  @addGroupBy = (field, fieldName, aggregators = []) ->
    if @_activeGroupings.findOne(name: fieldName) then return
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
    @_dataView.setGrouping (val for key, val of @_groupings)
  # <-- grouping

  @install = ->
    # Handle changes to client rendered fitlers
    @_activeFilters.find(type: 'client').observe
      added: @addColumnFilter
      changed: @addColumnFilter
      removed: @removeColumnFilter

    for column in columns when column.groupable
      column.header =
        buttons: [
          cssClass: "icon-highlight-off",
          command: "toggle-grouping",
          tooltip: "Group table by #{column.name}"
        ]

    headerButtonsPlugin = new Slick.Plugins.HeaderButtons()
    headerButtonsPlugin.onCommand.subscribe (e, args) =>
      column = args.column
      button = args.button
      command = args.command
      @_activeGroupings.find(name: column.name).observe
        removed: =>
          console.log 'removed'
          button.cssClass = "icon-highlight-off"
          button.tooltip = "Group table by #{column.name}"
          @grid.updateColumnHeader(column.id)

      if command == "toggle-grouping"
        if button.cssClass == "icon-highlight-on"
          @removeGroupBy column.name
          button.cssClass = "icon-highlight-off"
          button.tooltip = "Group table by #{column.name}"
        else
          @addGroupBy (column.groupable.transform or column.field), column.name, (column.groupable.aggregators or [])
          button.cssClass = "icon-highlight-on"
          button.tooltip = "Remove group #{column.name}"

    groupItemMetadataProvider = new Slick.Data.GroupItemMetadataProvider()
    @_dataView = new Slick.Data.DataView
      groupItemMetadataProvider: groupItemMetadataProvider,
      inlineFilters: true

    grandTotalsColumns = (column for column in columns when column.grandTotal)
    @totalsDataProvider = TotalsDataProvider @_dataView, columns, grandTotalsColumns
    @grid = new Slick.Grid '#slickgrid', @totalsDataProvider, columns, options
    @grid.registerPlugin headerButtonsPlugin


    comparer = (sortcol) -> (a, b) ->
      x = a[sortcol]
      y = b[sortcol]
      if x == y then 0 else if x > y then 1 else -1

    @grid.onSort.subscribe (e, args) =>
      sortdir = args.sortAsc ? 1 : -1;
      sortcol = args.sortCol.field
      @_dataView.sort(comparer(sortcol), args.sortAsc)

    $(@grid.getHeaderRow()).delegate ":input", "change keyup", (e) =>
      columnId = $(e.target).data("columnId");
      if columnId
        column = (columns.filter (column) -> column.id == columnId)[0]
        where = column.search.where or 'client'
        if $(e.target).val().length
          @addFilter where, column.name, $(e.target).val(),
            fltr = {}
            fltr[column.field] = regex: "#{$(e.target).val()}"
            fltr
        else
          @removeFilter where, column.name
    @grid.onHeaderRowCellRendered.subscribe (e, args) ->
      $(args.node).empty()
      if args.column.search
        if args.column.search.dateRange
          $('<input id="date-range-filter" class="searchbox" type="text" placeholder="Filter on date">').appendTo args.node
          DateRangeFilter.install $('#date-range-filter'), args.column.search.dateRange
        else
          $('<span class="glyphicon glyphicon-search searchbox" aria-hidden="true"></span>').appendTo(args.node)
          $("<input id='searchbox-#{args.column.field}' type='text' class='searchbox'>")
             .data("columnId", args.column.id)
             .appendTo(args.node)
      else
        $("<div class='searchdisabled'>&nbsp;</div>").appendTo args.node

    @_dataView.onRowCountChanged.subscribe (e, args) =>
      @totalsDataProvider.updateTotals()
      dl = if @_dataView.getLength() then @_dataView.getLength() else 0
      @grid.invalidateRows [dl, dl+1]
      @grid.updateRowCount()
      @grid.render()
    @_dataView.onRowsChanged.subscribe (e, args) =>
      # totals rows, the two last ones, should always be visually updated
      dl = if @_dataView.getLength() then @_dataView.getLength() else 0
      args.rows.push dl
      args.rows.push dl + 1
      @grid.invalidateRows args.rows
      @grid.updateRowCount()
      @grid.render()
    # register the group item metadata provider to add expand/collapse group handlers
    @grid.registerPlugin groupItemMetadataProvider
    #grid.registerPlugin(headerMenuPlugin);
    @grid.init()
    columnpicker = new Slick.Controls.ColumnPicker columns, @grid, options

    if initializeData
      Meteor.call serverMethod, (err, items) => @setGridData( items.map Helpers.addId )

  @
