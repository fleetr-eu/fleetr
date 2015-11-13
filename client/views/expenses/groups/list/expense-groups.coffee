Template.expenseGroups.onRendered ->
  Session.set 'selectedExpenseGroupId', null

Template.expenseGroups.events
  'click .deleteExpenseGroup': ->
    Meteor.call 'removeExpenseGroup', Session.get('selectedExpenseGroupId')
    Session.set 'selectedExpenseGroupId', null
  'rowsSelected': (e, t) ->
    Session.set 'selectedExpenseGroupId', e.fleetrGrid.data[e.rowIndex]._id

Template.expenseGroups.helpers
  selectedExpenseGroupId: -> Session.get('selectedExpenseGroupId')
  expenseGroupsConfig: ->
    cursor: ExpenseGroups.find()
    columns: [
      id: "name"
      field: "name"
      name: "#{TAPi18n.__('expenseGroups.name')}"
      width:80
      sortable: true
      search: where: 'client'
    ,
      id: "description"
      field: "description"
      name: "#{TAPi18n.__('expenseGroups.description')}"
      width:160
      sortable: true
      search: where: 'client'
    ]
    options:
      enableCellNavigation: true
      enableColumnReorder: false
      showHeaderRow: true
      explicitInitialization: true
      forceFitColumns: true
