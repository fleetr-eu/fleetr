addId = (item) -> item.id = item._id; item;
dateFormatter = (row, cell, value) -> if value then new Date(value).toLocaleDateString 'en-US' else ''
euroFormatter = (row, cell, value) -> "&euro; #{if value then value else '0'}"

getDateRow = (field) -> (row) -> new Date(row[field]).toLocaleDateString 'en-US'

sumTotalsFormatter = (sign) -> (totals, columnDef) ->
  val = totals.sum && totals.sum[columnDef.field];
  if val
    "#{sign} " + ((Math.round(parseFloat(val)*100)/100));
  else ''
sumEuroTotalsFormatter = sumTotalsFormatter '&euro;'


columns = [
  { id: "nextTechnicalCheck", name: "Next Check", field: "nextTechnicalCheck", width:120, sortable: true, formatter: dateFormatter}
  { id: "name", name: "Name", field: "name", sortable: true, allowSearch: true}
]

aggregatorsBasic = [
  new Slick.Data.Aggregators.Sum('total')
  new Slick.Data.Aggregators.Sum('totalVATIncluded')
  new Slick.Data.Aggregators.Sum('discount')
]
aggregatorsQuantity = aggregatorsBasic.concat [
  new Slick.Data.Aggregators.Sum('quantity')
]

options =
  enableCellNavigation: false
  enableColumnReorder: false
  showHeaderRow: true
  headerRowHeight: 30
  explicitInitialization: true
  forceFitColumns: true

MyGrid = new FleetrGrid options, columns, (callback) ->
  Meteor.call 'getMaintenanceVehicles', moment().add(30, 'days').toISOString(), (err, items) ->
    console.log 'getMaintenanceVehicles', items
    callback items

Template.maintenanceReport.onRendered ->
  MyGrid.install()

Template.maintenanceReport.helpers
  activeGroupings:  MyGrid.activeGroupingsCursor
  activeFilters:    MyGrid.activeFiltersCursor

Template.maintenanceReport.events
  'click .removeGroupBy': ->
    MyGrid.removeGroupBy @name
  'click .removeFilter': ->
    MyGrid.removeFilter @type, @name
    # temp
    if @type is 'server'
      Meteor.call 'getExpenses', (err, expenses) ->
        MyGrid.setGridData( expenses.map addId )
  'click #groupByNextCheck': (event, tpl) -> MyGrid.addGroupBy 'nextTechnicalCheck', 'Next Check', aggregatorsBasic
  'click #resetGroupBy': (event, tpl) -> MyGrid.resetGroupBy()
  'apply.daterangepicker #date-range-filter': (event,p) ->
    startDate = $('#date-range-filter').data('daterangepicker').startDate
    endDate = $('#date-range-filter').data('daterangepicker').endDate
    start = startDate.format('YYYY-MM-DD')
    stop = endDate.format('YYYY-MM-DD')
    range = {$gte: start, $lte: stop}
    MyGrid.addFilter 'server', 'Date', "#{start} - #{stop}",
      {startDate: startDate.toISOString(), endDate: endDate.toISOString()}
    Meteor.call 'getExpenses', startDate.toISOString(), endDate.toISOString(), (err, expenses) ->
      MyGrid.setGridData( expenses.map addId )
