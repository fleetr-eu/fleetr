getDateRow = (field) -> (row) -> new Date(row[field]).toLocaleDateString 'en-US'

fleetrGridConfig =
  columns: [
    id: "date"
    field: "timestamp"
    name: "Date"
    width:50
    sortable: true
    formatter: FleetrGrid.Formatters.dateFormatter
    search:
      where: 'server'
      dateRange: DateRanges.history
    groupable:
      transform: getDateRow 'timestamp'
      aggregators: aggregatorsBasic
  ,
    id: "description"
    field: "description"
    name: "Description"
    width:100
    hidden:true
    search: where: 'client'
  ,
    id: "remainingDays"
    field: "remainingDays"
    name: "Days to"
    width:20
    hidden:true
    search: where: 'client'  
  , 
    id: "vehicle"
    field: "vehicleName"
    name: "#{TAPi18n.__('expenses.vehicle')}"
    width:60
    sortable: true
    groupable: true
    search: where: 'client'
  ,
    id: "driver"
    field: "driverName"
    name: "#{TAPi18n.__('expenses.driver')}"
    width:80
    hidden: true
    sortable: true
    groupable: true
    search: where: 'client'
  ]
  options:
    enableCellNavigation: true
    enableColumnReorder: false
    showHeaderRow: true
    explicitInitialization: true
    forceFitColumns: true
  cursor: ->
    Vehicles.find {},
      transform: (vehicle) ->
        driver = Drivers.findOne _id: vehicle.driver
        _.extend expense,
          expenseTypeName: ExpenseTypes.findOne({_id: expense.expenseType})?.name
          expenseGroupName: ExpenseGroups.findOne({_id: expense.expenseGroup})?.name
          driverName: Drivers.findOne({_id: expense.driver})?.name
          vehicleName: vehicle?.name
          fleetName: Fleets.findOne(_id: vehicle?.allocatedToFleet)?.name

Template.upcomingEventsReport.helpers
  fleetrGridConfig: -> fleetrGridConfig
  pageTitle: -> "#{TAPi18n.__('reports.upcomingEvents.title')}"
