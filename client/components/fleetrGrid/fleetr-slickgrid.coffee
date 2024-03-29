Helpers =
  addId: (item) -> item.id = item._id; item
  columnId: (column) -> column.id or column.field

# Component that wraps SlickGrid and uses Meteorish constructs
@FleetrGrid = (gridId, options, columns, serverMethodOrCursor, remoteMethodParams) ->

  @grid = null
  @_dataView = null
  @_blazeCache = templates: {}, views: {}
  @_data = []

  if serverMethodOrCursor.observe
    @cursor = serverMethodOrCursor
  else if typeof serverMethodOrCursor == 'function'
    Tracker.autorun =>
      @cursor = serverMethodOrCursor()
      @_refreshData() if @_refreshData
  else if typeof serverMethodOrCursor == 'string'
    @serverMethod = serverMethodOrCursor
  else
    throw new Exception 'Argument serverMethodOrCursor is not a string or cursor'

  window.addEventListener 'resize', _.debounce (=> @resize?()), 200

  # populates the data for the grid
  @setGridData = (data, store = true) =>
    @_data = data if store
    if @_dataView
      @_dataView.beginUpdate()
      @_dataView.setItems data
      @grid.autosizeColumns()
      @_dataView.endUpdate()

      # update and render totals row
      @totalsDataProvider.updateTotals()
      length = @dataViewLength()
      @grid.invalidateRows [0..length + 1]
      @grid.render()

  @resize = => @grid.resizeCanvas()

  @_ensureCorrectRowSelection = ->
    selectionSet = false
    if @_selectedItem? then for i in [0..@grid.getDataLength()] when @grid.getDataItem(i)._id is @_selectedItem._id
      @grid.setSelectedRows [i]
      selectionSet = true
    @grid?.setSelectedRows [] unless selectionSet

  # updates a document in the grid
  @updateDocument = (doc) =>
    @setGridData(@_data.map (d) -> if d._id == doc._id then Helpers.addId doc else d)
    @_applyClientFilters()
    @_performSort()
  # add a new document into the grid
  @addDocument = (doc) =>
    @setGridData _.union([Helpers.addId doc], @_data)
    @_applyClientFilters()
    @_performSort()
  # remove a document from the grid
  @removeDocument = (doc) =>
    @setGridData(_.reject @_data, (d) -> d._id == doc._id)
    @_applyClientFilters()
    @_performSort()

  @dataViewLength = -> if @_dataView.getLength() then @_dataView.getLength() else 0

  # column filters -->
  @hasFilterableColumns = -> (c for c in columns when c.search).length > 0
  @_activeFilters = new Mongo.Collection null
  @activeFiltersCursor = @_activeFilters.find()
  @addFilter = (type, name, text, spec, refreshData = true) ->
    data = name: name, type: type, text: text, spec: spec
    @_activeFilters.upsert {name: name, type: type}, data
    @_refreshData() if refreshData and type == 'server'
    event = $.Event 'fleetr-grid-added-filter',
      filter: data
    $(".slickfleetr").trigger event
  @removeFilter = (type, name) ->
    data = name: name, type: type
    @_activeFilters.remove data
    @_refreshData() if type == 'server'
    event = $.Event 'fleetr-grid-removed-filter',
      filter: data
    $(".slickfleetr").trigger event
  @setColumnFilterValue = (column, filterValue)->
    $("#searchbox-#{Helpers.columnId column}").val(filterValue).trigger('change')
  @_applyClientFilters = =>
    @setGridData (@_data.filter @_filter), false
    @_ensureCorrectRowSelection()
  @_refreshData = =>
    @_beforeDataRefresh()
    if @serverMethod
      serverFilterSpec = {}
      items = @_activeFilters.find(type: 'server').fetch()
      _.extend serverFilterSpec, item.spec for item in items
      Meteor.call @serverMethod, serverFilterSpec, remoteMethodParams, (err, items) =>
        @setGridData( items.map Helpers.addId )
        @_applyClientFilters()
        @_performSort()
        @_afterDataRefresh()
    if @cursor
      @setGridData @cursor.map(Helpers.addId)
      @_applyClientFilters()
      @_performSort()
      @_afterDataRefresh()
  @_filter = (item) =>
    filters = @_activeFilters.find(type: 'client').fetch()
    for filter in filters
      for field of filter.spec
        return false if item[field] == undefined
        if filter.spec[field].filter
          return false if !filter.spec[field].filter "#{item[field]}"
        else if filter.spec[field].regex
          regex = new RegExp filter.spec[field].regex, 'i'
          return false if !"#{item[field]}".match regex
    true
  # <-- column filters

  # grouping -->
  @hasGroupableColumns = -> (c for c in columns when c.groupable).length > 0
  @_activeGroupings = new Mongo.Collection null
  @activeGroupingsCursor = @_activeGroupings.find()
  @_groupings = {}
  @resetGroupBy = ->
    @_groupings = {}
    @_activeGroupings.remove {}
    @_effectuateGroupings()
  @addGroupBy = (field, fieldName, aggregators = [], formatter = null, isCollapsed = false) ->
    if @_activeGroupings.findOne(name: fieldName) then return
    defaultFormatter = (g) ->
      "<strong>#{fieldName}:</strong> " + g.value + "  <span style='color:green'>(" + g.count + " items)</span>"
    @_groupings[fieldName] =
      getter: field
      formatter: (group) -> if formatter then formatter group, (-> defaultFormatter group) else defaultFormatter group
      aggregators: aggregators
      collapsed: isCollapsed
      aggregateCollapsed: true
      lazyTotalsCalculation: true
      comparer: (a, b) =>
        sortAsc = @_columnSortOrder[field]
        sortAsc = true if sortAsc is undefined
        result = if a.value is b.value then 0 else (if a.value > b.value then 1 else -1)
        result * (if sortAsc then 1 else -1)
    @_activeGroupings.insert name: fieldName
    @_effectuateGroupings()
  @removeGroupBy = (name) ->
    @_activeGroupings.remove name: name
    delete @_groupings[name]
    @_effectuateGroupings()
  @_effectuateGroupings = ->
    @_dataView?.setGrouping (val for key, val of @_groupings)
    getters = (val.getter for key, val of @_groupings)
    @grid?.setColumns _.filter columns, (col) -> not col.groupable?.hideColumn or col.field not in getters
    @_ensureCorrectRowSelection()
  # <-- grouping

  # sorting -->
  @_sortArgs = null
  @_columnSortOrder = {}
  @_performSort = (args = @_sortArgs) ->
    return unless args
    @_sortArgs = args
    # sort implementation that supports multi-column sort and custom
    # sorter functions per column
    if args.sortCol then sortCols = [sortAsc: args.sortAsc, sortCol: args.sortCol]
    else sortCols = args.sortCols

    @_dataView.sort (a, b) =>
      for sortColSpec in sortCols
        sortCol = sortColSpec.sortCol
        @_columnSortOrder[sortCol.field] = sortColSpec.sortAsc
        result =
          if sortCol.sorter
            n = sortCol.sorter(sortCol) a, b
            if n is undefined then 0 else n
          else
            valueA = a[sortCol.field]
            valueB = b[sortCol.field]
            if valueA == valueB then 0 else (if valueA > valueB then 1 else -1)
        result = result * (if sortColSpec.sortAsc then 1 else -1)
        return result if result isnt 0
      0
    @_ensureCorrectRowSelection()
  # <-- sorting

  # handler which is called before data is refreshed from the server
  @_beforeDataRefresh = =>
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

  @_renderBlazeTemplates = (row, col) ->
    node = $(".cell#{row}-#{col}")
    rowObject = @grid.getData().getItem(row)
    column = @grid.getColumns()[col]
    ctx =
      row: row
      col: col
      value: rowObject[column.field]
      column: column
      rowObject: rowObject
      grid: @
    tpl = @_blazeCache.templates["#{row}:#{col}"]

    # ensure that the parent node exists
    if domNode = node.get(0)
      # check if we can reuse the view
      if view = @_blazeCache.views["#{row}:#{col}"]
        # check if the view's parent element is different than the current one
        # this can happen when slickgrid discards the old dom element
        if view._domrange.parentElement != domNode
          # if so, ensure that the node is empty and reattach the view
          $(".cell#{row}-#{col}").empty()
          view._domrange.attach domNode
        view.dataVar.set ctx # update the data of the view
      else
        # ensure the parent node is empty
        $(".cell#{row}-#{col}").empty()
        # render the view
        view = Blaze.renderWithData tpl, ctx, domNode
        @_blazeCache.views["#{row}:#{col}"] = view

  @destroy = ->
    @cursorHandle.stop() if @cursorHandle?.stop
    @_activeFiltersObserve.stop() if @_activeFiltersObserve?.stop
    @_activeGroupingsObserve.stop() if @_activeGroupingsObserve?.stop
    Blaze.remove(@_blazeCache.views[key]) for key of @_blazeCache.views
    @_blazeCache.views = {}
    @_blazeCache.templates = {}

  @install = (initializeData = true) ->

    # Handle changes to client rendered filters
    @_activeFiltersObserve = @_activeFilters.find(type: 'client').observe
      removed: (filter) =>
        $("#searchbox-#{field}").val('') for field of filter.spec
        @_applyClientFilters()
      added: @_applyClientFilters
      changed: @_applyClientFilters

    # render buttons in column header for groupable columns
    for column in columns when column.groupable
      column.header =
        buttons: [
          cssClass: "icon-highlight-off",
          command: "toggle-grouping",
          tooltip: "Group table by #{column.name}"
        ]

    # set alignment css class for column with alignment strategy
    for column in columns when column.align
      column.cssClass = "alignment-#{column.align}"

    headerButtonsPlugin = new Slick.Plugins.HeaderButtons()
    headerButtonsPlugin.onCommand.subscribe (e, args) =>
      column = args.column
      button = args.button
      command = args.command
      @_activeGroupingsObserve = @_activeGroupings.find(name: column.name).observe
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
          @addGroupBy (column.groupable.transform or column.field), column.name, (column.groupable.aggregators or []), (column.groupable.headerFormatter), (column.groupable.isCollapsedByDefault or false)
          button.cssClass = "icon-highlight-on"
          button.tooltip = "Remove group #{column.name}"

    groupItemMetadataProvider = new Slick.Data.GroupItemMetadataProvider()
    @_dataView = new Slick.Data.DataView
      groupItemMetadataProvider: groupItemMetadataProvider,
      inlineFilters: true

    grandTotalsColumns = (column for column in columns when column.grandTotal)
    @totalsDataProvider = TotalsDataProvider @_dataView, columns, grandTotalsColumns
    @grid = new Slick.Grid "#slickgrid-#{gridId}", @totalsDataProvider, columns, options
    @grid.setSelectionModel new Slick.RowSelectionModel()
    @grid.registerPlugin headerButtonsPlugin

    @grid.onSelectedRowsChanged.subscribe (err, args) =>
      rowIndex = -1
      if args?.rows?.length > 0
        @_selectedItem = @getItemByRowId args.rows[0]
        rowIndex = args.rows[0]
      $("#slickgrid-#{gridId}").trigger $.Event 'rowsSelected',
        rowIndex: rowIndex
        fleetrGrid: @

    @grid.onSort.subscribe (e, args) =>
      @_performSort args

    searchInputHandler = (e) =>
      columnId = $(e.target).data("columnId")
      if columnId
        column = (columns.filter (column) -> Helpers.columnId(column) == columnId)[0]
        where = column.search.where or 'client'
        if $(e.target).val().length
          @addFilter where, column.name, $(e.target).val(),
            fltr = {}
            if column.search.filter and where is 'client'
              fltr[column.field] = filter: column.search.filter "#{$(e.target).val()}"
            else
              fltr[column.field] = regex: "#{$(e.target).val()}"
            fltr
        else
          @removeFilter where, column.name

    $(@grid.getHeaderRow()).delegate ":input", "change keyup", _.debounce(searchInputHandler, 500)

    @grid.onHeaderRowCellRendered.subscribe (e, args) =>
      $(args.node).empty()
      if args.column.search
        $('<span class="glyphicon glyphicon-search searchbox" aria-hidden="true"></span>').appendTo(args.node)
        $("<input id='searchbox-#{Helpers.columnId args.column}' type='text' class='searchbox'>")
        .data("columnId", Helpers.columnId args.column)
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

    # get default sort settings for column
    @_sortArgs =
      grid: @grid
      multiColumnSort: true
      sortCols: []
    @grid.setSortColumns (for info in options.defaultSort or []
      asc = (info.direction?.match /^asc/i)?
      @_sortArgs.sortCols.push
        sortAsc: asc
        sortCol: _.find @grid.getColumns(), (col) -> col.id is info.columnId
      columnId: info.columnId, sortAsc: asc
    )

    # when this grid has previously been rendered, existing active filters
    # might still exist. This code ensures that the column searchbox values are
    # populated with the corresponding filter value. Otherwise filters will
    # be in place, but the searchboxes remain empty.
    for activeFilter in @_activeFilters.find().fetch()
      for field of activeFilter.spec
        $("#searchbox-#{field}").val activeFilter.spec[field].text

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


    @getItemByRowId = (rowId) => @_dataView.getItem rowId

    @_effectuateGroupings()
    @_refreshData() if initializeData

    if @cursor
      flag = false
      @cursorHandle = @cursor.observe
        added: (doc) => @addDocument(doc) if flag
        changed: (newDoc, oldDoc) => @updateDocument(newDoc, oldDoc) if flag
        removed: (oldDoc) => @removeDocument(oldDoc) if flag
      flag = true

  @ # return this object
