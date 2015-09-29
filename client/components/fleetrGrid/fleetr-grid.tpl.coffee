Template.fleetrGrid.onRendered ->
  Session.set 'selectedDocument', null
  @data.myGrid.install()

Template.fleetrGrid.helpers
  activeGroupings: (tpl) -> Template.currentData().myGrid.activeGroupingsCursor
  activeFilters:   (tpl) -> Template.currentData().myGrid.activeFiltersCursor
  selectedDocument:      -> Session.get 'selectedDocument'

Template.fleetrGrid.events
  'click .removeGroupBy': (e, tpl) ->
    tpl.data.myGrid.removeGroupBy @name

  'click .removeFilter': (e, tpl) ->
    tpl.data.myGrid.removeFilter @type, @name

  'apply.daterangepicker #date-range-filter': (event, tpl) ->
    startDate = $('#date-range-filter').data('daterangepicker').startDate
    endDate = $('#date-range-filter').data('daterangepicker').endDate
    start = startDate.format('YYYY-MM-DD')
    stop = endDate.format('YYYY-MM-DD')
    range = {$gte: start, $lte: stop}
    tpl.data.myGrid.addFilter 'server', 'Maintenance Date', "#{start} - #{stop}",
      {maintenanceDateMin: startDate.toISOString(), maintenanceDateMax: endDate.toISOString()}

  'rowsSelected #slickgrid': (event) ->
    Session.set 'selectedDocument', event.fleetrGrid.data[event.rowIndex]

  'click #createLink': -> $('#slickgrid').trigger $.Event 'createLinkClicked'
  'click #editLink': -> $('#slickgrid').trigger $.Event 'editLinkClicked', document: @
  'click #deleteLink': -> $('#slickgrid').trigger $.Event 'deleteLinkClicked', document: @
