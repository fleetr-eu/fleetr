Template.fleetrGrid.onRendered ->
  console.log 'fleetrGrid::onRendered', @
  @data.myGrid.install()

Template.fleetrGrid.helpers
  activeGroupings:  -> @data.myGrid.activeGroupingsCursor
  activeFilters:    -> @data.myGrid.activeFiltersCursor

Template.fleetrGrid.events
  'click .removeGroupBy': (e, tpl) ->
    tpl.data.myGrid.removeGroupBy @name

  'click .removeFilter': (e, tpl) ->
    tpl.data.myGrid.removeFilter @type, @name

  'apply.daterangepicker #date-range-filter': (event, p) ->
    console.log 'xxxx, ', p
    startDate = $('#date-range-filter').data('daterangepicker').startDate
    endDate = $('#date-range-filter').data('daterangepicker').endDate
    start = startDate.format('YYYY-MM-DD')
    stop = endDate.format('YYYY-MM-DD')
    range = {$gte: start, $lte: stop}
    MyGrid.addFilter 'server', 'Maintenance Date', "#{start} - #{stop}",
      {maintenanceDateMin: startDate.toISOString(), maintenanceDateMax: endDate.toISOString()}
  'rowsSelected #slickgrid': (event) ->
    console.log 'rowsSelected #slickgrid', event
