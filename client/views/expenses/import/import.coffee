Template.expensesImport.helpers
  droppedFiles: -> _.toArray Template.instance().droppedFiles.get()
  dropHandlers: ->
    tpl = Template.instance()
    onDrop: (files) ->
      tpl.droppedFiles.set tpl.droppedFiles.get().concat(_.toArray files)
      for file in files
        file.processed = false
        reader = new FileReader
        reader.onload = (e) ->
          data = e.target.result
          workbook = XLSX.read data, type: 'binary'
          sheetNames = workbook.SheetNames
          sheetNames.forEach (sheetName) ->
            sheet = workbook.Sheets[sheetName]
            if Object.keys(sheet)?.length
              expenses = XLSX.utils.sheet_to_json(sheet)
              tpl.importedExpenses.set tpl.importedExpenses.get().concat(expenses)

        reader.readAsBinaryString file
        file.processed = true


Template.expensesImport.events
  'click #clearExpenses': (e, tpl) ->
    tpl.importedExpenses.set []
  'click #importExpenses': (e, tpl) ->
    expenses = tpl.importedExpenses.get().map (exp) ->
      licensePlate = exp['ДК Номер'] or exp.licensePlate
      unitPriceWithVAT = parseInt exp['Единична стойност с ДДС']
      quantity = parseInt exp['количество']
      totalVATIncluded = unitPriceWithVAT * quantity
      # FIX: Improve calculation or import
      total = totalVATIncluded / (1 + Settings.VAT)
      console.log total, totalVATIncluded, quantity, Settings.VAT

      quantity: quantity
      date: moment(exp['Дата на зареждане'], "DD.MM.YYYY").toDate()
      odometer: parseInt exp['Одометър'] or 0
      location: exp['Обект']
      VATIncluded: true
      invoiceNr: exp['№ фактура']
      description: exp['Забележки']
      total: total
      totalVATIncluded: totalVATIncluded
      vehicle: Vehicles.findOne(licensePlate: licensePlate)?._id
      # FIX: make the following user selectable
      expenseType: tpl.$('#importedExpenseType').val()
      expenseGroup: tpl.$('#importedExpenseGroup').val()
      # =======================================

    # context = Schema.expenses.namedContext("importingExpenses")
    # for exp in expenses
    #   unless context.validate exp
    #     console.log context.invalidKeys()
    tpl.importedExpenses.set []
    tpl.droppedFiles.set []
    Meteor.call 'expenses/import', expenses

Template.expensesImport.onCreated ->
  @droppedFiles = new ReactiveVar []
  @importedExpenses = new ReactiveVar []

Template.expensesImport.helpers
  tableSettings: ->
    fields: [
      { key: 'количество', label: 'Количество', headerClass: 'text-center', cellClass: 'text-right'}
      { key: 'Дата на зареждане', label: 'Дата на зареждане', headerClass: 'text-center', cellClass: 'text-center', sortOrder: 0, sortDirection: 'descending'}
      { key: 'Час', label: 'Час', headerClass: 'text-center', cellClass: 'text-center'}
      { key: 'Одометър', label: 'Одометър', headerClass: 'text-center', cellClass: 'text-center'}
      { key: 'Обект', label: 'Обект', headerClass: 'text-center', cellClass: 'text-center'}
      { key: 'Тип Гориво', label: 'Тип гориво', headerClass: 'text-center', cellClass: 'text-center' }
      { key: 'ДК Номер', label: 'ДК номер', headerClass: 'text-center', cellClass: 'text-center' }
      { key: 'Град', label: 'Град', headerClass: 'text-center', cellClass: 'text-center' }
      { key: 'Единична стойност с ДДС', label: 'Единична стойност с ДДС', headerClass: 'text-center', cellClass: 'text-right'}
    ]
    filters: ['expenseFilter']
  expenses: -> Template.instance().importedExpenses.get()
  processed: -> @processed
  expenseTypes: -> ExpenseTypes.find()
  expenseGroups: -> ExpenseGroups.find()
