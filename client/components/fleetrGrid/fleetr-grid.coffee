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
@FleetrGrid = (options, columns, serverMethodOrCursor) ->

  @grid = null
  @_dataView = null
  @data = []

  console.log 'typeof ',  typeof serverMethodOrCursor
  if serverMethodOrCursor.observe
    @cursor = serverMethodOrCursor
  else if typeof serverMethodOrCursor == 'string'
    @serverMethod = serverMethodOrCursor
  else
    throw new Exception 'Argument serverMethodOrCursor is not a string or cursor'


  # populates the data for the grid
  @setGridData = (data, store = true) =>
    @data = data if store
    console.log 'data', data
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
  @addFilter = (type, name, text, spec, refreshData = true) ->
    @_activeFilters.upsert {name: name, type: type}, {name: name, type: type, text: text, spec:spec}
    @_refreshData() if refreshData and type == 'server'
  @removeFilter = (type, name) ->
    @_activeFilters.remove name: name, type: type
    @_refreshData() if type == 'server'
    $('#date-range-filter').val('')
  @_applyClientFilters = =>
    @setGridData (@data.filter @_filter), false
  @_refreshData = =>
    @_beforeDataRefresh()
    serverFilterSpec = {}
    items = @_activeFilters.find(type: 'server').fetch()
    _.extend serverFilterSpec, item.spec for item in items
    console.log 'refreshData with serverFilter', serverFilterSpec
    Meteor.call @serverMethod, serverFilterSpec, (err, items) =>
      @setGridData( items.map Helpers.addId )
      @_applyClientFilters()
      @_afterDataRefresh()
  @_filter = (item) =>
    filters = @_activeFilters.find(type: 'client').fetch()
    for filter in filters
      for field of filter.spec when item[field]
        regex = new RegExp filter.spec[field].regex, 'i'
        if !"#{item[field]}".match regex
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

  # handler which is called before data is refreshed from the server
  @_beforeDataRefresh = =>
    console.log '_beforeDataRefresh'
    if not @loadingIndicator
      if $('#fleetrGridSpinner').length # reuse the element if it's already available in the dom
        @loadingIndicator = $ 'fleetrGridSpinner'
      else
        @loadingIndicator = $('<div id="fleetrGridSpinner"><div class="spinner"><div class="bounce1"></div><div class="bounce2"></div><div class="bounce3"></div></div></div>').appendTo document.body
    @_loadingIndicatorShowId = Meteor.setTimeout((=>@loadingIndicator.fadeIn()), 500)

  # handler which is called after data has been refreshed from the server
  @_afterDataRefresh = ->
    if @_loadingIndicatorShowId
      Meteor.clearTimeout @_loadingIndicatorShowId
      @_loadingIndicatorShowId = null
    @loadingIndicator?.fadeOut()

  @install = (initializeData = true) ->

    # Handle changes to client rendered filters
    @_activeFilters.find(type: 'client').observe
     removed: (filter) =>
         $("#searchbox-#{field}").val('') for field of filter.spec
         @_applyClientFilters()
     added: @_applyClientFilters
     changed: @_applyClientFilters

    for column in columns when column.groupable
      column.header =
        buttons: [
          cssClass: "icon-highlight-off",
          command: "toggle-grouping",
          tooltip: "Group table by #{column.name}"
        ]

    for column in columns when column.align
      column.cssClass = "alignment-#{column.align}"


    headerButtonsPlugin = new Slick.Plugins.HeaderButtons()
    headerButtonsPlugin.onCommand.subscribe (e, args) =>
      column = args.column
      button = args.button
      command = args.command
      @_activeGroupings.find(name: column.name).observe
        removed: ((column) => =>
          button.cssClass = "icon-highlight-off"
          button.tooltip = "Group table by #{column.name}"
          @grid.updateColumnHeader(column.id)) column
        updated: ((column) => =>
          button.cssClass = "icon-highlight-on"
          button.tooltip = "Remove group #{column.name}"
          @grid.updateColumnHeader(column.id)) column


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
    @grid.setSelectionModel new Slick.RowSelectionModel()
    @grid.registerPlugin headerButtonsPlugin

    @grid.onSelectedRowsChanged.subscribe (err, args) =>
      if args?.rows?.length > 0
        $('#slickgrid').trigger $.Event 'rowsSelected',
          rowIndex: args.rows[0]
          fleetrGrid: @


    comparer = (sortcol) -> (a, b) ->
      x = a[sortcol]
      y = b[sortcol]
      if x == y then 0 else if x > y then 1 else -1

    @grid.onSort.subscribe (e, args) =>
      sortdir = args.sortAsc ? 1 : -1;
      sortcol = args.sortCol.field
      @_dataView.sort(comparer(sortcol), args.sortAsc)

    searchInputHandler = (e) =>
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

    $(@grid.getHeaderRow()).delegate ":input", "change keyup", _.debounce(searchInputHandler, 500)

    @grid.onHeaderRowCellRendered.subscribe (e, args) ->
      $(args.node).empty()
      if args.column.search
        if args.column.search.dateRange
          $('<input id="date-range-filter" class="searchbox" type="text" placeholder="Filter on date">').appendTo args.node
          # TODO: use input id that includes the column fieldname so in principal it would be
          #       possible to have more than 1 date range filter
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

    # when this grid has previously been rendered, existing active filters
    # might still exist. This code ensures that the column searchbox values are
    # populated with the corresponding filter value. Otherwise filters will
    # be in place, but the searchboxes remain empty.
    for activeFilter in @_activeFilters.find().fetch()
      if Object.keys(activeFilter.spec).length == 2
        # hacky; assume date filter when filter has two properties
        # TODO: fix this!
        console.warn 'Ass-uming this is a date filter:', activeFilter
        $('#date-range-filter').val activeFilter.text
      else
        for field of activeFilter.spec
          $("#searchbox-#{field}").val activeFilter.spec[field].regex

    # ensure the ui that controls grouping is in sync with existing active
    # groupings. this can happen when the grid has been previously been rendered
    # and the user navigates back to the grid
    $('.slick-header-button').each (index, headerButtonElement) =>
      headerButton = $ headerButtonElement
      column = headerButton.data 'column'
      grouping = @_activeGroupings.findOne name:column.name
      if grouping
        @addGroupBy (column.groupable.transform or column.field), column.name, (column.groupable.aggregators or [])
        headerButton.addClass 'icon-highlight-on'
        headerButton.removeClass 'icon-highlight-off'
        headerButton.attr 'title', "Remove group #{column.name}"
        headerButton.data 'button', {cssClass: "icon-highlight-on", command: "toggle-grouping", tooltip: "Remove group #{column.name}"}

    @_effectuateGroupings()
    @_refreshData() if initializeData

  @ # return this object

# Default column formatters
FleetrGrid.Formatters =
  dateFormatter: (row, cell, value) ->
    if value then new Date(value).toLocaleDateString 'en-US' else ''
  euroFormatter: (row, cell, value) ->
    "&euro; #{if value then value else '0'}"
  sumTotalsFormatter: (sign = '') -> (totals, columnDef) ->
    val = totals.sum && totals.sum[columnDef.field];
    if val
      "#{sign} " + ((Math.round(parseFloat(val)*100)/100));
    else ''
  buttonFormatter: (row, cell, value, column, rowObject) ->
    render = (button) ->
      if button.renderer
        button.renderer button.value, row, cell, column, rowObject
      else "<button>#{button.value}</button>"
    buttons = (render button for button in column.buttons)
    buttons.join ''

FleetrGrid.Formatters.sumEuroTotalsFormatter = FleetrGrid.Formatters.sumTotalsFormatter '&euro;'
FleetrGrid.Formatters.sumTotalsFormatterNoSign = FleetrGrid.Formatters.sumTotalsFormatter ''
