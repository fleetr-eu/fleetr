Template.expenseTypes.onRendered ->
  Session.set 'selectedExpenseTypeId', null

Template.expenseTypes.events
  'click .deleteExpenseType': ->
    Meteor.call 'removeExpenseType', Session.get('selectedExpenseTypeId')
    Session.set 'selectedExpenseTypeId', null
  'rowsSelected': (e, t) ->
    Session.set 'selectedExpenseTypeId', e.fleetrGrid.data[e.rowIndex]._id

Template.expenseTypes.helpers
  selectedFleetId: -> Session.get('selectedExpenseTypeId')
  expenseTypesConfig: ->
    cursor: ExpenseTypes.find()
    columns: [
      id: "name"
      field: "name"
      name: "#{TAPi18n.__('expenseTypes.name')}"
      width:120
      sortable: true
      search: where: 'client'
    ,
      id: "unitOfMeasure"
      field: "unitOfMeasure"
      name: "#{TAPi18n.__('expenseTypes.unitOfMeasure')}"
      width:40
      sortable: true
      search: where: 'client'
    ,
      id: "description"
      field: "description"
      name: #{TAPi18n.__('expenseTypes.description')}"
      width:200
      sortable: true
      search: where: 'client'
    ]
    options:
      enableCellNavigation: true
      enableColumnReorder: false
      showHeaderRow: true
      explicitInitialization: true
      forceFitColumns: true
