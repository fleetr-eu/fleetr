Meteor.methods
  'expenses/import': (expenses) ->
    for exp in expenses
      Expenses.insert exp
    # context = Schema.expenses.namedContext("importingExpenses")
    # for exp in expenses
    #   unless context.validate exp
    #     console.log context.invalidKeys()
  getExpenses: (filter = {}) ->
    searchObject = {}
    if filter.startDate and filter.endDate
      searchObject.date = $gte: new Date(filter.startDate), $lte: new Date(filter.endDate)

    Expenses.find(searchObject).map (expense) ->
      expense.expenseTypeName = ExpenseTypes.findOne({_id: expense.expenseType})?.name
      expense.expenseGroupName = ExpenseGroups.findOne({_id: expense.expenseGroup})?.name
      expense.driverName = Drivers.findOne({_id: expense.driver})?.name
      vehicle = Vehicles.findOne({_id: expense.vehicle})
      expense.vehicleName = vehicle?.name
      expense.fleetName = Fleets.findOne(_id: vehicle?.allocatedToFleet)?.name
      expense # return the expense
