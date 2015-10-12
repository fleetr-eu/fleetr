options = (config) ->
  _.extend
    rowHeight: 30
    headerRowHeight: 30
  ,
    config.options

Template.fleetrGrid.onCreated ->
  Session.set 'selectedDocument', null
  config = @data.config
  @grid = new FleetrGrid options(config), config.columns, config.remoteMethod or config.cursor
  if config.customize and typeof config.customize == 'function'
    config.customize @grid

Template.fleetrGrid.onRendered ->
  @grid.install()

grid = -> Template.instance().grid

Template.fleetrGrid.helpers
  activeGroupings: -> grid()?.activeGroupingsCursor
  activeFilters:   -> grid()?.activeFiltersCursor
  displayGrouping: -> grid()?.hasGroupableColumns()
  displayFilters:  -> grid()?.hasFilterableColumns()

Template.fleetrGrid.events
  'click .removeGroupBy': (e, tpl) ->
    grid().removeGroupBy @name

  'click .removeFilter': (e, tpl) ->
    grid().removeFilter @type, @name

  'apply.daterangepicker #date-range-filter': (event, tpl) ->
    startDate = $('#date-range-filter').data('daterangepicker').startDate
    endDate = $('#date-range-filter').data('daterangepicker').endDate
    start = startDate.format('YYYY-MM-DD')
    stop = endDate.format('YYYY-MM-DD')
    range = {$gte: start, $lte: stop}
    grid().addFilter 'server', 'Maintenance Date', "#{start} - #{stop}",
      {maintenanceDateMin: startDate.toISOString(), maintenanceDateMax: endDate.toISOString()}
