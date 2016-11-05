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
              importedExpenses = XLSX.utils.sheet_to_json(sheet)
              processedExpenses = importedExpenses.map (exp) ->
                licensePlate = exp['ДК Номер'] or exp.licensePlate
                unitPriceWithVAT = parseInt exp['Единична стойност с ДДС']
                quantity = parseInt exp['количество']
                totalVATIncluded = unitPriceWithVAT * quantity
                total = totalVATIncluded / (1 + Settings.VAT)
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
                expenseType: tpl.$('#importedExpenseType').val()
                expenseGroup: tpl.$('#importedExpenseGroup').val()

              context = Schema.expenses.namedContext("importingExpenses")
              for row, index in processedExpenses
                unless context.validate row
                  validationErrors = tpl.validationErrors.get()
                  for key, value in context.invalidKeys()
                    validationErrors.push
                      workbook: file.name
                      sheet: sheetName
                      row: index + 2
                      error: context.keyErrorMessage key.name
                  # validationErrors.push "Sheet '#{sheetName}' Row '#{index+2}': #{context.keyErrorMessage key.name}" for key, value in context.invalidKeys()
                  tpl.validationErrors.set validationErrors

              tpl.importedExpenses.set tpl.importedExpenses.get().concat(importedExpenses)
              tpl.processedExpenses.set tpl.processedExpenses.get().concat(processedExpenses)

        reader.readAsBinaryString file
        file.processed = true

Template.expensesImport.events
  'click #clearExpenses': (e, tpl) ->
    tpl.validationErrors.set []
    tpl.importedExpenses.set []
    tpl.processedExpenses.set []
    tpl.droppedFiles.set []
  'click #importExpenses': (e, tpl) ->
    expenses = tpl.processedExpenses.get()
    tpl.validationErrors.set []
    tpl.processedExpenses.set []
    tpl.importedExpenses.set []
    tpl.droppedFiles.set []
    Meteor.call 'expenses/import', expenses

Template.expensesImport.onCreated ->
  @droppedFiles = new ReactiveVar []
  @importedExpenses = new ReactiveVar [] # raw data imported from excel sheets
  @processedExpenses = new ReactiveVar [] # processed data ready to be validated and added to collection
  @validationErrors = new ReactiveVar [] # array of invalid rows in excel sheets after validation against schema

Template.expensesImport.helpers
  tableSettingsValidationErrors: ->
    fields: [
      { key: 'workbook', label: 'работна книга' }
      { key: 'sheet', label: 'лист'}
      { key: 'row', label: 'ред'}
      { key: 'error', label: 'грешка'}
    ]
    showFilter: false
  tableSettingsImportedData: ->
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
  importedExpenses: -> Template.instance().importedExpenses.get()
  processedExpenses: -> Template.instance().processedExpenses.get()
  validationErrors: -> Template.instance().validationErrors.get()
  processed: -> @processed
  validated: -> 'disabled' unless Template.instance().validationErrors.get().length == 0 and Template.instance().processedExpenses.get().length > 0
  expenseTypes: -> ExpenseTypes.find()
  expenseGroups: -> ExpenseGroups.find()
