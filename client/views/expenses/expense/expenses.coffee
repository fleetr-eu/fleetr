Template.expenses.helpers
  options: ->
    i18nRoot: 'expenses'
    collection: Expenses
    editItemTemplate: 'expense'
    removeItemMethod: 'removeExpense'
    gridConfig:
      cursor: Expenses.find {},
        transform: (doc) -> _.extend doc,
          vehicleName: Vehicles.findOne(_id: doc.vehicle)?.name
          driverName: Drivers.findOne(_id: doc.driver)?.name
          expenseGroupName: ExpenseGroups.findOne(_id: doc.expenseGroup)?.name
          expenseTypeName: ExpenseTypes.findOne(_id: doc.expenseType)?.name
      columns: [
        id: "expenseGroup"
        field: "expenseGroupName"
        name: "#{TAPi18n.__('expenses.expenseGroup')}"
        width: 60
        sortable: true
        groupable: true
        search: where: 'client'
      , 
        id: "expenseType"
        field: "expenseTypeName"
        name: "#{TAPi18n.__('expenses.expenseType')}"
        width:60
        sortable: true
        groupable: true
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
      ,
        id: "odometer"
        field: "odometer"
        name: "#{TAPi18n.__('expenses.odometer')}"
        hidden: true
        width: 40
        sortable: true
        search: where: 'client'
      ,
        id: "invoiceNr"
        field: "invoiceNr"
        name: "#{TAPi18n.__('expenses.invoiceNr')}"
        width:40
        hidden: true
        sortable: true
        search: where: 'client'
      ,
        id: "date"
        field: "date"
        name: "#{TAPi18n.__('expenses.date')}"
        width: 40
        sortable: true
        groupable: true
        search: where: 'client'  
        formatter: FleetrGrid.Formatters.dateFormatter
      ,
        id: "location"
        field: "location"
        name: "#{TAPi18n.__('expenses.location')}"
        width: 40
        sortable: true
        search: where: 'client'    
      ,
        id: "quantity"
        field: "quantity"
        name: "#{TAPi18n.__('expenses.quantity')}"
        width: 40
        sortable: true
        search: where: 'client'
      ,  
        id: "totalVATIncluded"
        field: "totalVATIncluded"
        name: "#{TAPi18n.__('expenses.totalVATIncluded')}"
        width: 40
        hidden: true
        sortable: true
        search: where: 'client'   
      ,  
        id: "vat"
        field: "vat"
        name: "#{TAPi18n.__('expenses.vat')}"
        width: 40
        hidden: true
        sortable: true
        search: where: 'client'   
      ,  
        id: "discount"
        field: "discount"
        name: "#{TAPi18n.__('expenses.discount')}"
        width: 40
        hidden: true
        sortable: true
        search: where: 'client'   
      ,  
        id: "total"
        field: "total"
        name: "#{TAPi18n.__('expenses.total')}"
        width: 40
        sortable: true
        search: where: 'client' 
      ]
      options:
        enableCellNavigation: true
        enableColumnReorder: false
        showHeaderRow: true
        explicitInitialization: true
        forceFitColumns: true