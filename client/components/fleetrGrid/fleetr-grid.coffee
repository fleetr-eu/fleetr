guid = ->
  s4 = ->
    Math.floor((1 + Math.random()) * 0x10000).toString(16).substring(1)
  "#{s4()}#{s4()}-#{s4()}-#{s4()}-#{s4()}-#{s4()}#{s4()}#{s4()}"

Meteor.startup ->
  options = (config) ->
    _.extend
      rowHeight: 30
      headerRowHeight: 30
    ,
      config.options

  Template.fleetrGrid.onCreated ->
    Session.set 'selectedDocument', null
    @data.uuid = guid()
    config = @data.config
    @grid = new FleetrGrid @data.uuid, options(config), config.columns, config.remoteMethod or config.cursor, config.remoteMethodParams
    if config.customize and typeof config.customize == 'function'
      config.customize @grid
    for column in config.columns when column.formatter
      column.formatter = column.formatter.bind @grid
    if config.onCreated
      config.onCreated @grid

  Template.fleetrGrid.onRendered ->
    @grid.install()
    config = @data.config
    config.onInstall @grid if config.onInstall
  Template.fleetrGrid.onDestroyed ->
    @grid.destroy()

  grid = -> Template.instance().grid

  Template.fleetrGrid.helpers
    id:              -> @uuid
    activeGroupings: -> grid()?.activeGroupingsCursor
    activeFilters:   -> grid()?.activeFiltersCursor
    displayGrouping: -> grid()?.hasGroupableColumns()
    displayFilters:  -> grid()?.hasFilterableColumns()
    grid:            -> grid()
    height:          -> Template.currentData().height or 'calc(100vh - 150px)'
    paginationConfig:-> Template.currentData().config.pagination


  Template.fleetrGrid.events
    'rowsSelected': (e, t) ->
      unless e.rowIndex is -1
        [t.grid, t.row] = [e.fleetrGrid, e.rowIndex]
        Session.set 'selectedItemId', t.grid.getItemByRowId(t.row)?._id
      else Session.set 'selectedItemId', null

    'click .removeGroupBy': (e, tpl) ->
      grid().removeGroupBy @name

    'click .removeFilter': (e, tpl) ->
      grid().removeFilter @type, @name
