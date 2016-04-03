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
    @grid = new FleetrGrid @data.uuid, options(config), config.columns, config.remoteMethod or config.cursor
    if config.customize and typeof config.customize == 'function'
      config.customize @grid
    for column in config.columns when column.formatter
      column.formatter = column.formatter.bind @grid
    if config.onCreated
      config.onCreated @grid

  Template.fleetrGrid.onRendered ->
    @grid.install()
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
    height:          -> Template.currentData().height or '500px'
    paginationConfig:-> Template.currentData().config.pagination


  Template.fleetrGrid.events
    'click .removeGroupBy': (e, tpl) ->
      grid().removeGroupBy @name

    'click .removeFilter': (e, tpl) ->
      grid().removeFilter @type, @name
