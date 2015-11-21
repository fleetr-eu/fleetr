Template.expenseTypes.helpers
  options: ->
    i18nRoot: 'expenseTypes'
    collection: ExpenseTypes
    editItemTemplate: 'expenseType'
    removeItemMethod: 'removeExpenseType'
    gridConfig:
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
        name: "#{TAPi18n.__('expenseTypes.description')}"
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
