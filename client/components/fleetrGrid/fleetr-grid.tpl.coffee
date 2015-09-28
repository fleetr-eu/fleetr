Template.fleetrGrid.onRendered ->
  console.log 'fleetrGrid::onRendered', @
  @data.myGrid.install()

Template.fleetrGrid.helpers
  activeGroupings: (tpl,a,b,c) -> Template.currentData().myGrid.activeGroupingsCursor
  activeFilters:   (tpl) -> Template.currentData().myGrid.activeFiltersCursor

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
    console.log 'rowsSelected #slickgrid', event
