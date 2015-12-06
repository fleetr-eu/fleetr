Template.expenseGroups.helpers
  options: ->
    i18nRoot: 'expenseGroups'
    collection: ExpenseGroups
    editItemTemplate: 'expenseGroup'
    removeItemMethod: 'removeExpenseGroup'
    gridConfig:
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
