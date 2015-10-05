Template.fleetrGrid.onCreated ->
  Session.set 'selectedDocument', null
  config = @data.config
  @grid = new FleetrGrid config.options, config.columns, config.remoteMethod or config.cursor
  if config.customize and typeof config.customize == 'function'
    config.customize @grid
Template.fleetrGrid.onRendered ->
  @grid.install()

grid = -> Template.instance().grid

Template.fleetrGrid.helpers
  activeGroupings: (tpl) -> grid()?.activeGroupingsCursor
  activeFilters:   (tpl) -> grid()?.activeFiltersCursor
  selectedDocument:      -> Session.get 'selectedDocument'

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

  'rowsSelected #slickgrid': (event) ->
    Session.set 'selectedDocument', event.fleetrGrid.data[event.rowIndex]

  'click #createLink': -> $('#slickgrid').trigger $.Event 'createLinkClicked'
  'click #editLink': -> $('#slickgrid').trigger $.Event 'editLinkClicked', document: Session.get('selectedDocument')
  'click #deleteLink': -> $('#slickgrid').trigger $.Event 'deleteLinkClicked', document: Session.get('selectedDocument')
