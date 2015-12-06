getDateRow = (field) -> (row) -> new Date(row[field]).toLocaleDateString 'en-US'

aggregatorsBasic = [
  new Slick.Data.Aggregators.Sum 'total'
  new Slick.Data.Aggregators.Sum 'totalVATIncluded'
  new Slick.Data.Aggregators.Sum 'discount'
  new Slick.Data.Aggregators.Sum 'vat'
]
aggregatorsQuantity = aggregatorsBasic.concat [
  new Slick.Data.Aggregators.Sum 'quantity'
]
fleetrGridConfig =
  columns: [
    id: "date"
    field: "timestamp"
    name: "Date"
    width:120
    sortable: true
    formatter: FleetrGrid.Formatters.dateFormatter
    search:
      where: 'server'
      dateRange: DateRanges.history
    groupable:
      transform: getDateRow 'timestamp'
      aggregators: aggregatorsBasic
  ,
    id: "type"
    field: "expenseTypeName"
    name: "Type"
    sortable: true
    search:
      where: 'client'
    groupable:
      aggregators: aggregatorsQuantity
  ,
    id: "description"
    field: "description"
    name: "Description"
    width:100
    hidden:true
    search:
      where: 'client'
  ,
    id: "expenseGroup"
    field: "expenseGroupName"
    name: "Group"
    sortable: true
    hidden: true
    search:
      where: 'client'
    groupable:
      aggregators: aggregatorsBasic
  ,
    id: "vehicle"
    field: "vehicleName"
    name: "Vehicle"
    sortable: true
    search:
      where: 'client'
    groupable:
      aggregators: aggregatorsBasic
  ,
    id: "driver"
    field: "driverName"
    name: "Driver"
    sortable: true
    search:
      where: 'client'
    groupable:
      aggregators: aggregatorsBasic
  ,
    id: "fleet"
    field: "fleetName"
    name: "Fleet"
    sortable: true
    search:
      where: 'client'
    groupable:
      aggregators: aggregatorsBasic
  ,
    id: "invoiceNo"
    field: "invoiceNr"
    name: "Invoice NO."
    sortable: true
    width:75
    hidden:true
  ,
    id: "quantity"
    field: "quantity"
    name: "Quantity"
    width:75
    sortable: true
    align: "right"
    groupTotalsFormatter: FleetrGrid.Formatters.sumTotalsFormatterNoSign
  ,
    id: "totalVat"
    field: "totalVATIncluded"
    name: "Total+VAT"
    width:75
    sortable: true
    grandTotal: true
    align: "right"
    formatter: FleetrGrid.Formatters.euroFormatter
    groupTotalsFormatter: FleetrGrid.Formatters.sumEuroTotalsFormatter
  ,
    id: "amountVat"
    field: "vat"
    name: "VAT"
    width:50
    sortable: true
    grandTotal: true
    align: "right"
    formatter: FleetrGrid.Formatters.euroFormatter
    groupTotalsFormatter: FleetrGrid.Formatters.sumEuroTotalsFormatter
  ,
    id: "amountDiscount"
    field: "discount"
    name: "Discount"
    width:75
    sortable: true
    grandTotal: true
    align: "right"
    formatter: FleetrGrid.Formatters.euroFormatter
    groupTotalsFormatter: FleetrGrid.Formatters.sumEuroTotalsFormatter
  ,
    id: "total"
    field: "total"
    name: "Total"
    width:80
    sortable: true
    grandTotal: true
    align: "right"
    formatter: FleetrGrid.Formatters.euroFormatter
    groupTotalsFormatter: FleetrGrid.Formatters.sumEuroTotalsFormatter
  ]
  options:
    enableCellNavigation: true
    enableColumnReorder: false
    showHeaderRow: true
    explicitInitialization: true
    forceFitColumns: true
  cursor: ->
    Expenses.find {},
      transform: (expense) ->
        vehicle = Vehicles.findOne _id: expense.vehicle
        _.extend expense,
          expenseTypeName: ExpenseTypes.findOne({_id: expense.expenseType})?.name
          expenseGroupName: ExpenseGroups.findOne({_id: expense.expenseGroup})?.name
          driverName: Drivers.findOne({_id: expense.driver})?.name
          vehicleName: vehicle?.name
          fleetName: Fleets.findOne(_id: vehicle?.allocatedToFleet)?.name

Template.expenseReport.helpers
  fleetrGridConfig: -> fleetrGridConfig
  pageTitle: -> "#{TAPi18n.__('reports.expenses.title')}"
